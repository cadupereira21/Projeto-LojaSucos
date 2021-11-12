use LojaSuco
go

/*
 /*CADASTRO DE CLIENTES*/
exec CadastrarCliente 'Carlos', '19996060222', 'Avenida A, 123, Piracicaba-SP', '12345678910'
exec CadastrarCliente 'Gustavo', '19998675647', 'Avenida B, 321, Limeira-SP', '10987654321'
exec CadastrarCliente 'Pedro', '19994758686', 'Avenida C, 213, Piracicaba-SP', '10978645312', 'Simples'
exec CadastrarCliente 'Ana', '19996867575', 'Avenida D, 231, Piracicaba-SP', '12365478901', 'Especial'


 /*CADASTRO DE FORNECEDORES + INSUMO*/
exec CadastrarFornecedor 'Serasa', '1934267878', 'Avenida Rio Das Pedras, 555, Piracicaba-SP', '12345678900015', 'Laranja', 25
exec CadastrarInsumo 'Abacaxi', 3.9, 4
exec CadastrarFornecedor 'Morango', '19998768855', 'Em frente à Dedini', '98765432100019', 'Laranja', 22
exec CadastrarInsumo 'Morango', 5.9, 5

 /*CADASTRO SUCOS*/
exec CadastrarSuco '300mLL', 'Laranja', 'Simples', 0.3
exec CadastrarSuco '1LL', 'Laranja', 'Simples', 1
exec CadastrarSuco '15LL', 'Laranja', 'Simples', 1.5
exec CadastrarSuco '5LL', 'Laranja', 'Simples', 5
exec CadastrarSuco '300mLA', 'Abacaxi', 'Simples', 0.3
exec CadastrarSuco '1LA', 'Abacaxi', 'Simples', 1
exec CadastrarSuco '15LA', 'Abacaxi', 'Simples', 1.5
exec CadastrarSuco '5LA', 'Abacaxi', 'Simples', 5
exec CadastrarSuco '300mLMEL', 'Melancia', 'Simples', 0.3
exec CadastrarSuco '1LMEL', 'Melancia', 'Simples', 1
exec CadastrarSuco '15LMEL', 'Melancia', 'Simples', 1.5
exec CadastrarSuco '5LMEL', 'Melancia', 'Simples', 5
exec CadastrarSuco '1LDA', 'Detox de Abacaxi', 'Especial', 1
exec CadastrarSuco '1LMELGH', 'Melancia com Gengibre e Hortelã', 'Gourmet', 1


/*CADASTRO PEDIDOS DE CLIENTES*/
exec NovoPedidoCliente 0, 0, 0, 'Débito'
exec AdicionarSucoAoPedido 0, '1LL', 1
exec AdicionarSucoAoPedido 0, '15LMEL', 1

exec NovoPedidoCliente 2, 0, 1 
exec AdicionarSucoAoPedido 1, '1LL', 1
exec AdicionarSucoAoPedido 1, '15LMEL', 1

exec NovoPedidoCliente 0, 5, 0, 'Crédito'
exec AdicionarSucoAoPedido 2, '1LL', 1


/*CADASTRO DE PEDIDOS DE FORNECEDOR*/
exec NovoPedidoFornecedor 4, 0, 1
exec NovoPedidoFornecedor 0, 0, 1 /*fornecedor não existe*/
exec NovoPedidoFornecedor 4, 5, 1 /*insumo não existe*/
exec NovoPedidoFornecedor 4, 0, -1 /*quantidade não valida*/
exec NovoPedidoFornecedor 4, 2, 1 /*fornecedor não fornece*/

/*BUSCAR CLIENTE*/
select * from dadosClientes
EXEC BuscarCliente @id = 0
EXEC BuscarCliente @id = -1 /*ID inexistente*/
EXEC BuscarCliente @nome = 'CARLOS' 
EXEC BuscarCliente @nome = 'C' /*NOME NÃO EXISTE*/
EXEC BuscarCliente @telefone = '19996060222'
EXEC BuscarCliente @telefone = '19998565235' /*Telefone nao existe*/
EXEC BuscarCliente @cpf = '12345678910'
EXEC BuscarCliente @cpf = '1238975839' /*CPF não existe*/
EXEC BuscarCliente @planoMensal = 'simples'
EXEC BuscarCliente @planoMensal = 'duplicado' /*plano não existe*/
EXEC BuscarCliente /*clientes sem plano*/


/*BUSCAR FORNECEDORES*/
select * from dadosFornecedores
Exec BuscarFornecedor @id = 4
Exec BuscarFornecedor @id = 6 /*ID nao existe*/
Exec BuscarFornecedor @nome = 'serasa'
Exec BuscarFornecedor @nome = 'pedro' /*nome nao existe*/
Exec BuscarFornecedor @telefone = '1934267878'
Exec BuscarFornecedor @telefone = '1934264852' /*telefone nao existe*/

/*BUSCAR ITEM_FORNECIMENTO*/
Exec BuscarItemFornecimento @id = 0
Exec BuscarItemFornecimento @id = -1 /*id nao existe*/
Exec BuscarItemFornecimento @idInsumo = 0
Exec BuscarItemFornecimento @idInsumo = -1 /*idInsumo nao existe*/
Exec BuscarItemFornecimento @nomeInsumo = 'Laranja'
Exec BuscarItemFornecimento @nomeInsumo = 'banana' /*id nao existe*/
Exec BuscarItemFornecimento @idFornecedor = 4
Exec BuscarItemFornecimento @idFornecedor = -1 /*idFornecedor nao existe*/
Exec BuscarItemFornecimento @nomeFornecedor = 'Serasa'
Exec BuscarItemFornecimento @nomeFornecedor = 'monica' /*nomeFornecedor nao existe*/
Exec BuscarItemFornecimento @valor = 3.9
Exec BuscarItemFornecimento @valor = 100 /*valor nao existe*/
*/

/*
/*EXCLUSAO DE CLIENTE*/
exec ExcluirCliente
*/

