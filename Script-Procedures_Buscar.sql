use LojaSuco
go

create procedure BuscarCliente
@id smallint = null,
@nome char(25) = null,
@telefone char(11) = null,
@cpf char(11) = null,
@planoMensal char(8) = null
as
begin transaction

	if @id is not null
	begin
		if @id not in (select id from cliente)
		begin
			print 'Este ID de cliente não existe!'
			rollback transaction
			return -1
		end
		else
		begin
			select * from dadosClientes 
			where id= @id
			commit transaction
			return 0
		end
	end

	if @nome is not null
	begin
		if LOWER(@nome) not in (select nome from dadosClientes)
		begin
			print 'Não existe cliente com este nome!'
			rollback transaction
			return -1
		end
		else if @telefone is not null
		begin
			if @telefone not in (select telefone from dadosClientes)
			begin
				print 'Não existe um cliente com este telefone'
				rollback transaction
				return -1
			end
			select * from dadosClientes where nome = @nome AND telefone = @telefone
			commit transaction
			return 0
		end
		else
		begin
			select * from dadosClientes where nome like ('%'+@nome+'%')
			commit transaction
			return 0
		end
	end

	if @telefone is not null
	begin
		if @telefone not in (select telefone from dadosClientes)
		begin
			print 'Não existe um cliente com este telefone'
			rollback transaction
			return -1
		end
		else
		begin
			select * from dadosClientes where telefone = @telefone
			commit transaction
			return 0
		end
	end

	if @cpf is not null
	begin
		if @cpf not in (select cpf from dadosClientes)
		begin
			print 'Não existe cliente com este CPF!'
			rollback transaction
			return -1
		end
		else
		begin
			select * from dadosClientes where cpf = @cpf
			commit transaction
			return 0
		end
	end

	if @planoMensal is not null
	begin
		if LOWER(@planoMensal) not in ('simples', 'especial', 'gourmet')
		begin
			print 'Este tipo de plano mensal não existe!'
			rollback transaction
			return -1
		end

		select * from dadosClientes where planoMensal = @planoMensal
		commit transaction
		return 0
	end

	/*CASO NENHUM ARGUMENTO SEJA INSERIDO, RETORNAREMOS OS CLIENTE QUE NAO POSSUEM PLANO MENSAL!*/
	select * from dadosClientes where planoMensal is null
	commit transaction
	return 0
go

create procedure BuscarFornecedor
@id smallint = null,
@nome char(25) = null,
@telefone char(11) = null,
@cnpj char(11) = null
as
begin transaction

	if @id is not null
	begin
		if @id not in (select id from fornecedor)
		begin
			print 'Não existe fornecedor com esse ID!'
			rollback transaction
			return -1
		end
		else
		begin
			select * from dadosFornecedores where id = @id
			commit transaction
			return 0
		end
	end

	if @nome is not null
	begin
		if LOWER(@nome) not in (select nome from dadosFornecedores)
		begin
			print 'Não existe fornecedor com este nome!'
			rollback transaction
			return -1
		end
		else
		begin
			select * from dadosFornecedores where nome = @nome
			commit transaction
			return 0
		end
	end

	if @telefone is not null
	begin
		if @telefone not in (select telefone from dadosFornecedores)
		begin
			print 'Não existe fornecedor com este telefone!'
			rollback transaction
			return -1
		end
		else
		begin
			select * from dadosFornecedores where telefone = @telefone
			commit transaction
			return 0
		end
	end

	if @cnpj is not null
	begin
		if @cnpj not in (select cnpj from dadosFornecedores)
		begin
			print 'Não existe fornecedor com este CNPJ!'
			rollback transaction
			return -1
		end
		else
		begin
			select * from dadosFornecedores where cnpj = @cnpj
			commit transaction
			return 0
		end
	end
go

create procedure BuscarItemFornecimento
@id smallint = null,
@idInsumo smallint = null,
@nomeInsumo char(20) = null,
@idFornecedor smallint = null,
@nomeFornecedor char(25) = null,
@cnpjFornecedor char(15) = null,
@valor smallmoney = null
as
begin transaction

	if @id is not null
	begin
		if @id not in (select id from itemFornecimento)
		begin
			print 'Não existe Item_Fornecimento com este ID!'
			rollback transaction
			return -1
		end

		select * from itemFornecimento
		where id = @id
		commit transaction
		return 0;
	end

	if @idInsumo is not null
	begin
		if @idInsumo not in (select idInsumo from itemFornecimento)
		begin
			print 'Não existe Item_Fornecimento com este Id de Insumo!'
			rollback transaction
			return -1
		end

		select * from itemFornecimento
		where idInsumo = @idInsumo
		commit transaction
		return 0;
	end

	if @nomeInsumo is not null
	begin
		if LOWER(@nomeInsumo) not in (select nomeProduto from itemFornecimento)
		begin
			print 'Não existe Item_Fornecimento com este nome de Insumo!'
			rollback transaction
			return -1
		end

		select * from itemFornecimento
		where nomeProduto = @nomeInsumo
		commit transaction
		return 0;
	end

	if @idFornecedor is not null
	begin
		if @idFornecedor not in (select idFornecedor from itemFornecimento)
		begin
			print 'Não existe Item_Fornecimento com este Id de Fornecedor!'
			rollback transaction
			return -1
		end

		select * from itemFornecimento
		where idFornecedor = @idFornecedor
		commit transaction
		return 0;
	end

	if @nomeFornecedor is not null
	begin
		if LOWER(@nomeFornecedor) not in (select nomeFornecedor from itemFornecimento)
		begin
			print 'Não existe Item_Fornecimento com este nome de Fornecedor!'
			rollback transaction
			return -1
		end

		select * from itemFornecimento
		where nomeFornecedor = @nomeFornecedor
		commit transaction
		return 0;
	end

	if @cnpjFornecedor is not null
	begin
		if @cnpjFornecedor not in (select cnpj from itemFornecimento)
		begin
			print 'Não existe Item_Fornecimento com este nome de Fornecedor!'
			rollback transaction
			return -1
		end

		select * from itemFornecimento
		where cnpj = @cnpjFornecedor
		commit transaction
		return 0;
	end

	if @valor is not null
	begin
		if @valor not in (select valor from itemFornecimento)
		begin
			print 'Não existe Item_Fornecimento com este valor!'
			rollback transaction
			return -1
		end

		select * from itemFornecimento
		where valor = @valor
		commit transaction
		return 0;
	end

	print 'Deve inserir pelo menos um atributo'
	return -1
	rollback transaction
go