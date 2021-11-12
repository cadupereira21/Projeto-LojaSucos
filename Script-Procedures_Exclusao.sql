use LojaSuco
go

create procedure ExcluirPedidoCliente
@idPedido smallint = NULL,
@idCliente smallint = NULL,
@dataPedido date = NULL
as
begin transaction
	if @idPedido != null
	begin
		delete from compor_suco
		where @idPedido in (select id from pedido_cliente)

		delete from pedido_Cliente
		where id = @idPedido

		commit transaction
		return 0
	end

	if @idCliente is not null
	begin

		delete from compor_suco
		where idPedido in (select id from pedido_cliente
							where idCliente = @idCliente)

		delete from pedido_cliente
		where idCliente = @idCliente
		
		commit transaction
		return 0
	end

	if @dataPedido != null AND @dataPedido in (select dataPedido from pedido_cliente)
	begin
		rollback transaction
		return -1
	end

	rollback transaction
	return 1
go

create procedure ExcluirCliente
@id smallint = NULL,
@nome char(25) = NULL,
@telefone char(11) = NULL,
@cpf char(11) = NULL
as
begin transaction

	if @id is not null
	begin

		if @id not in (select id from cliente)
		begin
			print 'Este Id não existe!'
			rollback transaction
			return -1
		end

		if @id in (select idCliente from pedido_cliente)
		begin
			declare @ret int
			exec @ret = ExcluirPedidoCliente @idCliente = @id

			if @ret != 0
			begin
				rollback transaction
				return @ret
			end
		end

		delete from cliente
		where id = @id

		if @@ROWCOUNT > 0
		begin
			commit transaction
			return 0
		end
		else
		begin
			rollback transaction
			return 1
		end
	end

	if @nome != null AND LOWER(@nome) in (select nome from pessoa)
	begin
		rollback transaction
		return -1
	end

	if @cpf != null AND @cpf in (select cpf from cliente)
	begin
		rollback transaction
		return -1
	end

	if @telefone != null AND @telefone in (select telefone from pessoa)
	begin
		rollback transaction
		return -1
	end

	print 'Estou aqui!'
	rollback transaction
	return 1
go

create procedure ExcluirPedidoFornecedor
@idPedido smallint = NULL,
@idFornecedor smallint = NULL,
@dataPedido date = NULL
as
begin transaction
	if @idPedido is not null
	begin
		if @idPedido not in (select id from pedido_fornecedor)
		begin
			print 'Não existe pedido de fornecedor com este ID!'
			rollback transaction
			return -1
		end
		else
		begin
			delete from compor_insumo
			where idPedido = @idPedido

			delete from pedido_fornecedor
			where id = @idPedido

			commit transaction
			return 0
		end
	end

	/*if @idFornecedor is not null
	begin
		if @idFornecedor not in (select id from dadosFornecedores)
		begin
			print 'Não existe fornecedor com este ID!'
			rollback transaction
			return -1
		end

		delete from compor_insumo
		where idItemFornecimento in (select id from item_fornecimento where idFornecedor = @idFornecedor)

		delete from pedido_fornecedor
		where idPedido in (select  from compor_insumo)
	end*/
	print 'Pelo menos um parâmetro deve ser especificado' 
	rollback transaction
	return 1
go

create procedure ExcluirItemFornecimento
@id smallint = null,
@idFornecedor smallint
as
begin transaction
	if @id is not null
	begin
		if @id not in (select id from itemFornecimento)
		begin
			print 'Não existe item_fornecimento com este id!'
			rollback transaction
			return -1
		end
		else
		begin
			delete from item_fornecimento
			where id = @id

			commit transaction
			return 0
		end
	end

	if @idFornecedor is not null
	begin
		if @idFornecedor not in (select id from dadosFornecedores)
		begin
			print 'Nao existe fornecedor com este id'
			rollback transaction
			return -1
		end
		else
		begin
			delete from item_fornecimento
			where idFornecedor = @idFornecedor

			commit transaction
			return 0
		end
	end

	rollback transaction
	return 1
go

create procedure ExcluirFornecedor
@id smallint = null,
@nome char(25) = NULL,
@telefone char(11) = NULL,
@cnpj char(11) = NULL
as
begin transaction

	if @id is not null
	begin
		if @id not in (select id from dadosFornecedores)
		begin
			print 'Não existe fornecedor com este ID!'
			rollback transaction
			return -1
		end

		declare @ret int
		declare @idP smallint
		select @idP = idPedido from compor_insumo where idItemFornecimento in (select id from item_fornecimento where idFornecedor = @id)
		exec @ret = ExcluirPedidoFornecedor @idPedido = @idP

		if @ret != 0
		begin
			print 'Problema na hora de excluir os pedidos deste fornecedor!'
			rollback transaction
			return @ret
		end

		exec @ret = ExcluirItemFornecimento @idFornecedor = @id

		if @ret != 0
		begin
			print 'Problema na hora de excluir os pedidos deste fornecedor!'
			rollback transaction
			return @ret
		end

		delete from fornecedor
		where id = @id

		commit transaction
		return 0
	end

go

create procedure ExcluirSuco
@id char(10)
as
begin transaction
	if @id is not null
	begin
		if UPPER(@id) not in (select id from suco)
		begin
			print 'Nao existe suco com este id!'
			rollback transaction
			return -1
		end

		declare @ret int
		declare @idP smallint
		select @idP = id from pedido_cliente
		where id in (select idPedido from compor_suco where idSuco = @id)

		if @idP is not null
		begin
			exec @ret = ExcluirPedidoCliente @idPedido = @idP

			if @ret != 0
			begin
				print 'Problema na hora de excluir os pedidos ligados a esse suco!'
				rollback transaction
				return @ret
			end
		end

		delete from produz
		where idSuco = @id

		delete from suco
		where id = @id

		commit transaction
		return 0
	end

	rollback transaction
	return 1
go