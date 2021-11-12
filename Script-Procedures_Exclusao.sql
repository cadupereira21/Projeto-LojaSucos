use LojaSuco
go

alter procedure ExcluirPedidoCliente
@idPedido smallint = NULL,
@idCliente smallint = NULL,
@dataPedido date = NULL
as
begin transaction
	if @idPedido != null
	begin
		rollback transaction
		return -1
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
	return -1
go

alter procedure ExcluirCliente
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