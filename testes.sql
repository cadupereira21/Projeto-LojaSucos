use LojaSuco
go

declare @ret int
exec @ret = CadastrarInsumo 'Morango', 30, 3
print @ret

select * from item_fornecimento