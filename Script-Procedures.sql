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

	/*VERIFICAÇÕES*/
	if @cpf in (select cpf from cliente)
	begin
		print 'Este CPF já está cadastrado no sistema!'
		rollback transaction
		return -1
	end

	if @telefone in (select telefone from pessoa)
	begin
		print 'Este telefone já está cadastrado no sistema'
		rollback transaction
		return -1
	end

	/*OBTENDO NOVO ID*/
	declare @codigo smallint;
	select @codigo = max(id)+1 from pessoa

	if @codigo is null
		set @codigo = 0

	/*INSERINDO NA TABELA*/
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

	/*VERIFICAÇÕES*/
	if @valor < 0
	begin
		print 'Valor não pode ser menor que 0!'
		rollback transaction
		return -1
	end

	if @idFornecedor not in (select id from fornecedor)
	begin
		print 'Este fornecedor não existe!'
		rollback transaction
		return -1
	end

	/*OBTENDO IDs*/
	declare @idInsumo smallint
	declare @idItemFornecimento smallint

	select @idItemFornecimento = max(id)+1 from item_fornecimento

	if @idItemFornecimento is null
		set @idItemFornecimento = 0

	/*para obter o id do insumo, verificamos se ele já existe na tabela*/
	if @nome not in (select nome from insumo)
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

	/*TODO: Checar se há cnpj ou telefone repetido*/
	if @cnpj in (select cnpj from fornecedor)
	begin
		print 'Este CNPJ já existe no sistema!'
		rollback transaction
		return -1
	end

	if @telefone in (select telefone from pessoa)
	begin
		print 'Este telefone já existe no sistema!'
		rollback transaction
		return -1
	end

	declare @codigo smallint;
	select @codigo = max(id)+1 from pessoa

	if @codigo is null
		set @codigo = 0

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

	declare @valor smallmoney

	if @tamanho not in (0.3, 1, 1.5, 5)
	begin
		print 'O tamanho de suco não existe!'
		rollback transaction
		return -1
	end

	if @sabor in (select sabor from suco where tamanho = @tamanho)
	begin
		print 'O suco já existe neste tamanho!'
		rollback transaction
		return -1
	end

	if LOWER(@tipo) not in ('simples', 'especial', 'gourmet')
	begin
		print 'O tipo de suco não existe!'
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
	end

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

create procedure AdicionarSucoAoPedido
@idPedido smallint,
@idSuco char(10),
@quantidade smallint
as
begin transaction

	/*VERIFICAÇÕES*/

	/*TODO: Verificar se já há um suco com o código inserido no pedido, se sim, aumentar somente sua quantidade e dar update no valor*/

	if @idPedido not in (select id from pedido_cliente)
	begin
		print 'O número de pedido não existe!'
		rollback transaction
		return -1
	end

	if @idSuco not in (select id from suco)
	begin
		print 'O suco não existe!'
		rollback transaction
		return -1
	end

	/*VARIÁVEIS*/
	declare @valor smallmoney;
	declare @isPlanoMensal bit;
	declare @tipoPlano char(8) = null;

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
			print 'Você não pode adicionar mais do que 2 sucos à um pedido de plano mensal!'
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
				print 'Você só pode adicionar pedidos simples à esse pedido!'
				rollback transaction
				return -1
			end
		end
		else if @tipoPlano = 'especial'
		begin
			if @idSuco in (select id from sucosGourmet)
			begin
				print 'Você só pode adicionar pedidos simples ou especiais à esse pedido!'
				rollback transaction
				return -1
			end
		end
	end

	/*INSERÇÃO NA TABELA + ATUALIZAÇÃO DO PEÇO DA VENDA EM PEDIDO_CLIENTE*/
	insert into compor_suco
	values (@idPedido, @idSuco, @quantidade)
	if @@ROWCOUNT > 0
	begin

		update pedido_cliente
		set valorTotal += @valor - desconto
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

	declare @idPedido smallint
	declare @valorTotal smallmoney = 0

	select @idPedido = max(id)+1 from pedido_cliente

	if @idPedido is null
		set @idPedido = 0

	insert into pedido_cliente
	values (@idPedido, @idCliente, getdate(), @isPlanoMensal, LOWER(@formaPagamento), @desconto, @valorTotal)
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

create procedure AdicionarInsumoAoPedido
@idPedido smallint,
@idItemFornecimento smallint,
@quantidade smallint
as
begin transaction

	declare @valor smallmoney;

	select @valor = (valor)*@quantidade from item_fornecimento
	where id = @idItemFornecimento

	insert into compor_suco
	values (@idPedido, @idItemFornecimento, @quantidade)
	if @@ROWCOUNT > 0
	begin

		update pedido_fornecedor
		set valorTotal = @valor
		where pedido_fornecedor.id = @idPedido

		declare @valorPedido smallmoney

		select @valorPedido = valorTotal from pedido_fornecedor
		where id = @idPedido

		if @valorPedido > 0
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

create procedure NovoPedidoFornecedor
@idItemFornecimento smallint,
@quantidade smallint,
@dataPedido date
as
begin transaction

	declare @idPedido smallint
	declare @valorTotal smallmoney = 0

	select @idPedido = max(id)+1 from pedido_fornecedor

	if @idPedido is null
		set @idPedido = 0

	select @valorTotal = valor*@quantidade from item_fornecimento
	where id = @idItemFornecimento

	insert into pedido_fornecedor
	values (@idPedido, getdate(), @valorTotal)
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