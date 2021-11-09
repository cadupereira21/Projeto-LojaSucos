use LojaSuco
go

create procedure cadastrar_cliente
@codigo smallint,
@nome char(15),
@telefone char(11),
@endereco char (60),
@cpf char(11),
@planoMensal char(8) = null
as
begin transaction
	insert into pessoa
	values (@codigo, @nome, @telefone, @endereco)
	if @@ROWCOUNT > 0
		begin
			insert into cliente
			values (@codigo, @cpf, @planoMensal)
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