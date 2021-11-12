use LojaSuco
go

create procedure CadastrarCliente
@nome char(15),
@telefone char(11),
@endereco char (60),
@cpf char(11),
@planoMensal char(8) = null
as
begin transaction

/*	VARI�VEIS A SEREM USADAS --------------------------------------------------------------- */
	declare @codigo smallint;
	select @codigo = max(id)+1 from pessoa
/* ---------------------------------------------------------------------------- */

/*	VERIFICA��ES --------------------------------------------------------------- */
	if @nome = ''
	begin
		print 'O nome n�o pode ser uma string vazia!'
		rollback transaction
		return -1
	end

	if LEN(@telefone) not in (10, 11)
	begin
		print 'O telefone deve possuir 10 ou 11 caracteres!'
		rollback transaction
		return -1
	end

	if @endereco = ''
	begin
		print 'O endere�o n�o pode ser uma string vazia!'
		rollback transaction
		return -1

	end

	if @endereco in (select endereco from pessoa)
	begin
		print 'Este endere�o
 j� est� cadastrado no sistema!'
		rollback transaction
		return -1
	end

	if @cpf = ''
	begin
		print 'O cpf n�o pode ser uma string vazia!'
		rollback transaction
		return -1
	end

	if @cpf in (select cpf from cliente)
	begin
		print 'Este CPF j� est� cadastrado no sistema!'
		rollback transaction
		return -1
	end

	if @telefone in (select telefone from pessoa)
	begin
		print 'Este telefone j� est� cadastrado no sistema'
		rollback transaction
		return -1
	end

	if LOWER(@planoMensal) not in ('simples', 'especial', 'gourmet')
	begin
		print 'Plano mensal inv�lido! Escolha entre Simples, Especial ou Gourmet!'
		rollback transaction
		return -1
	end

	if @codigo is null
		set @codigo = 0
/* ---------------------------------------------------------------------------- */

/*	OPERA��ES --------------------------------------------------------------- */
	insert into pessoa
	values (@codigo, LOWER(@nome), @telefone, LOWER(@endereco))
	if @@ROWCOUNT > 0
		begin
			insert into cliente
			values (@codigo, @cpf, LOWER(@planoMensal))
			if @@ROWCOUNT > 0
			begin
				commit transaction
				return 1
			end
			else
			begin
				rollback transaction
				return 0
			end
		end
	else
	begin
		rollback transaction
		return 0
	end
go

create procedure CadastrarInsumo
@nome char(20),
@valor smallmoney,
@idFornecedor smallint
as
begin transaction

/*	VARI�VEIS A SEREM USADAS --------------------------------------------------------------- */

	declare @idInsumo smallint
	declare @idItemFornecimento smallint

	select @idItemFornecimento = max(id)+1 from item_fornecimento

/* ----------------------------------------------------------------------------------------- */

/*	VERIFICA��ES --------------------------------------------------------------- */
	if @nome = ''
	begin
		print'O nome n�o pode ser uma string vazia!'
		rollback transaction
		return -1
	end

	if @valor < 0
	begin
		print 'Valor n�o pode ser menor que 0!'
		rollback transaction
		return -1
	end

	if @idFornecedor not in (select id from fornecedor)
	begin
		print 'Este fornecedor n�o existe!'
		rollback transaction
		return -1
	end

	if @idItemFornecimento is null
		set @idItemFornecimento = 0

	if @idInsumo is null
		set @idInsumo = 0

/* ----------------------------------------------------------------------------------------- */

/*	OPERA��ES --------------------------------------------------------------- */
	if LOWER(@nome) not in (select nome from insumo)
	begin
		select @idInsumo = max(id)+1 from insumo

		if @idInsumo is null
			set @idInsumo = 0

		insert into insumo
		values (@idInsumo, LOWER(@nome))
	end
	else
		select @idInsumo = (select id from insumo where nome = @nome)
	
	if @@ROWCOUNT > 0
	begin
		insert into item_fornecimento
		values (@idItemFornecimento, @idInsumo, @idFornecedor, @valor)
		if @@ROWCOUNT > 0
		begin
			commit transaction
			return 1
		end
		else
		begin
			rollback transaction
			return 0
		end
	end
	else
	begin
		rollback transaction
		return 0
	end
go

create procedure CadastrarFornecedor
@nome char(15),
@telefone char(11),
@endereco char(60),
@cnpj char(15),
@insumoFornecido char(20),
@valorInsumo smallmoney
as
begin transaction

/* VARI�VEIS --------------------------------------------------------- */

	declare @codigo smallint;
	select @codigo = max(id)+1 from pessoa

/* VERIFICA��ES --------------------------------------------------------- */

	if @nome = ''
	begin
		print 'O nome n�o pode ser uma string vazia!'
		rollback transaction
		return -1
	end

	if LEN(@telefone) not in (10, 11)
	begin
		print 'O telefone deve possuir 10 ou 11 caracteres!'
		rollback transaction
		return -1
	end

	if @endereco = ''
	begin
		print 'O endere�o n�o pode ser uma string vazia!'
		rollback transaction
		return -1

	end

	if @endereco in (select endereco from pessoa)
	begin
		print 'Este endere�o j� est� cadastrado no sistema!'
		rollback transaction
		return -1
	end

	if @cnpj = ''
	begin
		print 'O cnpj n�o pode ser string uma vazia!'
		rollback transaction
		return -1
	end

	if @cnpj in (select cnpj from fornecedor)
	begin
		print 'Este CNPJ j� existe no sistema!'
		rollback transaction
		return -1
	end

	if @telefone in (select telefone from pessoa)
	begin
		print 'Este telefone j� existe no sistema!'
		rollback transaction
		return -1
	end

	if @codigo is null
		set @codigo = 0

/* OPERA��ES --------------------------------------------------------- */
	insert into pessoa
	values (@codigo, LOWER(@nome), @telefone, LOWER(@endereco))
	if @@ROWCOUNT > 0
	begin

		insert into fornecedor
		values (@codigo, @cnpj)
		if @@ROWCOUNT > 0
		begin
			
			declare @ret int
			exec @ret = CadastrarInsumo @insumoFornecido, @valorInsumo, @codigo

			if @@ROWCOUNT > 0 AND @ret = 1
			begin
				commit transaction
				return 1
			end
			else
			begin
				rollback transaction
				return 0
			end

		end
		else
		begin

			rollback transaction
			return 0

		end
	end
	else
	begin

		rollback transaction
		return 0

	end
go

create procedure CadastrarSuco
@codigo char(10),
@sabor char(31),
@tipo char(8),
@tamanho float
as
begin transaction

/* VARI�VEIS ------------------------------------------------------------------- */

	declare @valor smallmoney

/* VERIFICA��ES ---------------------------------------------------------------- */
	if SUBSTRING(@codigo, 0, 2) not in ('1', '3', '5')
	begin
		print 'O codigo � invalido!'
		rollback transaction
		return -1
	end

	if @tamanho not in (0.3, 1, 1.5, 5)
	begin
		print 'O tamanho de suco n�o existe!'
		rollback transaction
		return -1
	end

	if LOWER(@sabor) in (select sabor from suco where tamanho = @tamanho)
	begin
		print 'O suco j� existe neste tamanho!'
		rollback transaction
		return -1
	end

	if LOWER(@tipo) not in ('simples', 'especial', 'gourmet')
	begin
		print 'O tipo de suco n�o existe!'
		rollback transaction
		return -1
	end
	else
	begin
		if LOWER(@tipo) = 'gourmet'
		begin
			if @tamanho = 0.3
				set @valor = 8.9
			else if @tamanho = 1
				set @valor = 13.9
			else if @tamanho = 1.5
				set @valor = 17.9
			else if @tamanho = 5
				set @valor = 54.9
		end
		else
		begin
			if LOWER(@tipo) = 'simples'
			begin
				if @tamanho = 0.3
					set @valor = 6.9
				else if @tamanho = 1
					set @valor = 11.9
				else if @tamanho = 1.5
					set @valor = 15.9
				else if @tamanho = 5
					set @valor = 34.9
			end
			else
			begin
				if @tamanho = 0.3
					set @valor = 7.9
				else if @tamanho = 1
					set @valor = 12.9
				else if @tamanho = 1.5
					set @valor = 16.9
				else if @tamanho = 5
					set @valor = 44.9
			end
		end
	end /* verifica��o automatiza o valor conforme o tamanho tamb�m! */

/* OPERA��ES -------------------------------------------------------------------- */

	insert into suco
	values (UPPER(@codigo), LOWER(@sabor), LOWER(@tipo), @tamanho, @valor)
	if @@ROWCOUNT > 0
	begin
		commit transaction
		return 1
	end
	else
	begin
		rollback transaction
		return 0
	end
go

create procedure AlterarComporSuco
@idPedido smallint,
@idSuco char(10),
@quantidade smallint
as
begin transaction

	update compor_suco
	set quantidade = quantidade+@quantidade
	where idPedido = @idPedido AND idSuco = @idSuco

	update pedido_cliente
	set valorTotal = (valorTotal + ((select valor from suco where id=@idSuco)*@quantidade))
	where id = @idPedido

	if @@ROWCOUNT > 0
	begin 
		commit transaction
		return 1
	end
	else
	begin
		rollback transaction
		return 0
	end
go

create procedure AdicionarSucoAoPedido
@idPedido smallint,
@idSuco char(10),
@quantidade smallint
as
begin transaction

/* VARIAVEIS ---------------------------------------------------------------- */

	declare @valor smallmoney;
	declare @isPlanoMensal bit;
	declare @tipoPlano char(8) = null;

/* VERIFICA��ES ---------------------------------------------------------------- */
	if @idPedido not in (select id from pedido_cliente)
	begin
		print 'O n�mero de pedido n�o existe!'
		rollback transaction
		return -1
	end

	if @idSuco not in (select id from suco)
	begin
		print 'O suco n�o existe!'
		rollback transaction
		return -1
	end

	if @quantidade < 0
	begin
		print 'Quantidade n�o pode ser negativa!'
		rollback transaction
		return -1
	end

/* OPERA��ES -------------------------------------------------------------------------------------------- */
	/*caso seja plano mensal, nao adicionaremos nada ao valor total na venda*/
	select @isPlanoMensal = isPlanoMensal from pedido_cliente where id = @idPedido
	
	if @isPlanoMensal = 0 OR @isPlanoMensal = null
		select @valor = (valor)*@quantidade from suco
		where id = @idSuco
	else
	begin
		declare @quantidadeTotalDoPedido smallint = 0;
		select @quantidadeTotalDoPedido = SUM(quantidade) from compor_suco where idPedido = @idPedido
		print @quantidadeTotalDoPedido

		if @quantidadeTotalDoPedido+@quantidade > 2
		begin
			print 'Voc� n�o pode adicionar mais do que 2 sucos � um pedido de plano mensal!'
			rollback transaction
			return -1
		end

		set @valor = 0

		select @tipoPlano = planoMensal from cliente 
		where cliente.id = (select idCliente from pedido_cliente 
							where id = @idPedido)

		if @tipoPlano = 'simples'
		begin
			if @idSuco not in (select id from sucosSimples)
			begin
				print 'Voc� s� pode adicionar pedidos simples � esse pedido!'
				rollback transaction
				return -1
			end
		end
		else if @tipoPlano = 'especial'
		begin
			if @idSuco in (select id from sucosGourmet)
			begin
				print 'Voc� s� pode adicionar pedidos simples ou especiais � esse pedido!'
				rollback transaction
				return -1
			end
		end
	end

	/*Verifica se j� h� um suco com o c�digo inserido no pedido, se sim, aumentar somente sua quantidade e dar update no valor*/
	if @idSuco in (select idSuco from compor_suco where idPedido = @idPedido)
	begin
		declare @ret int
		exec @ret = AlterarComporSuco @idPedido, @idSuco, @quantidade
		if @ret = 1
		begin
			commit transaction
			return @ret
		end
		else
		begin
			rollback transaction
			return @ret
		end
	end

	/*INSER��O NA TABELA + ATUALIZA��O DO PE�O DA VENDA EM PEDIDO_CLIENTE*/
	insert into compor_suco
	values (@idPedido, @idSuco, @quantidade)
	if @@ROWCOUNT > 0
	begin

		update pedido_cliente
		set valorTotal = (valorTotal+@valor)
		where pedido_cliente.id = @idPedido

		declare @valorPedido smallmoney

		select @valorPedido = valorTotal from pedido_cliente
		where id = @idPedido

		if @isPlanoMensal = null OR @isPlanoMensal = 0
		begin
			commit transaction
			return 1
		end
		else if @valorPedido = 0
		begin
			commit transaction
			return 1
		end
		else
		begin
			rollback transaction
		end
	end
	else
	begin
		rollback transaction
		return 0
	end
go

create procedure NovoPedidoCliente
@idCliente smallint,
@desconto smallint = 0,
@isPlanoMensal bit,
@formaPagamento char(15) = null
as
begin transaction

/* VARI�VEIS ----------------------------------------------------------------------------- */
	declare @idPedido smallint
	declare @valorTotal smallmoney = 0
	select @idPedido = max(id)+1 from pedido_cliente

/* VERIFICA��ES ----------------------------------------------------------------------------- */
	if @idCliente not in (select id from cliente)
	begin
		print 'O Id do cliente n�o existe!'
		rollback transaction
		return -1
	end

	if LOWER(@formaPagamento) not in ('debito', 'credito', 'dinheiro', 'transferencia')
	begin
		print 'A forma de pagamento deve ser uma das seguintes: D�bito, Cr�dito, Dinheiro ou Transfer�ncia'
		rollback transaction
		return -1
	end

	if @idPedido is null
		set @idPedido = 0

/* OPERA��ES ----------------------------------------------------------------------------- */
	insert into pedido_cliente
	values (@idPedido, @idCliente, getdate(), @isPlanoMensal, LOWER(@formaPagamento), @desconto, @valorTotal-@desconto)
	if @@ROWCOUNT > 0
	begin
		commit transaction
		return 1
	end
	else
	begin
		rollback transaction
		return 0
	end
go

create procedure NovoPedidoFornecedor
@idFornecedor smallint,
@idInsumo smallint,
@quantidade smallint
as
begin transaction

/* VARI�VEIS ------------------------------------------------------ */
	declare @idPedido smallint
	declare @valorTotal smallmoney = 0

	select @idPedido = max(id)+1 from pedido_fornecedor

	select @valorTotal = valor*@quantidade from item_fornecimento
	where idInsumo = @idInsumo AND idFornecedor = @idFornecedor

/* VERIFICA��ES ------------------------------------------------------ */
	if @idFornecedor not in (select id from fornecedor)
	begin
		print 'O fornecedor n�o existe!'
		rollback transaction
		return -1
	end

	if @idInsumo not in (select id from insumo)
	begin
		print 'O item solicitado n�o existe!'
	end

	if @idInsumo not in (select idInsumo from item_fornecimento where idFornecedor = @idFornecedor)
	begin
		print 'Este fornecedor n�o fornece o item desejado!'
		rollback transaction
		return -1
	end

	if @quantidade < 0
	begin
		print 'A quantidade n�o pode ser negativa!'
		rollback transaction
		return -1
	end

	if @idPedido is null
		set @idPedido = 0

/* OPERA��ES ------------------------------------------------------ */
	insert into pedido_fornecedor
	values (@idPedido, getdate(), @valorTotal)
	if @@ROWCOUNT > 0
	begin
		insert into compor_insumo
		values (@idPedido, (select id from item_fornecimento where idInsumo = @idInsumo AND idFornecedor = @idFornecedor), @quantidade)
		if @@ROWCOUNT > 0
		begin
			commit transaction
		return 1
		end
		else
		begin
			rollback transaction
			return 0
		end
	end
	else
	begin
		rollback transaction
		return 0
	end
go