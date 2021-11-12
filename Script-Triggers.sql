use LojaSuco
go

create trigger excluir_cliente
on cliente for delete
as
begin transaction
	
	delete from pessoa
	where id in (select id from deleted)

	if @@ROWCOUNT > 0
		commit transaction
	else
		rollback transaction
go