use LojaSuco
go

/*
CADASTRO DE CLIENTES

exec CadastrarCliente 'Carlos', '19996060222', 'Avenida A, 123, Piracicaba-SP', '12345678910'
exec CadastrarCliente 'Gustavo', '19998675647', 'Avenida B, 321, Limeira-SP', '10987654321'
exec CadastrarCliente 'Pedro', '19994758686', 'Avenida C, 213, Piracicaba-SP', '10978645312', 'Simples'
exec CadastrarCliente 'Ana', '19996867575', 'Avenida D, 231, Piracicaba-SP', '12365478901', 'Especial'


	CADASTRO DE FORNECEDORES + INSUMO

exec CadastrarFornecedor 'Serasa', '1934267878', 'Avenida Rio Das Pedras, 555, Piracicaba-SP', '12345678900015', 'Laranja', 25
exec CadastrarInsumo 'Abacaxi', 3.9, 4
exec CadastrarFornecedor 'Morango', '19998768855', 'Em frente à Dedini', '98765432100019', 'Laranja', 22
exec CadastrarInsumo 'Morango', 5.9, 5


 CADASTRO SUCOS
exec CadastrarSuco '300mLL', 'Laranja', 0.3, 6.9
exec CadastrarSuco '1LL', 'Laranja', 1, 10.9
exec CadastrarSuco '15LL', 'Laranja', 1.5, 15.9
exec CadastrarSuco '5LL', 'Laranja', 5, 34.9
exec CadastrarSuco '300mLA', 'Abacaxi', 0.3, 6.9
exec CadastrarSuco '1LA', 'Abacaxi', 1, 10.9
exec CadastrarSuco '15LA', 'Abacaxi', 1.5, 15.9
exec CadastrarSuco '5LA', 'Abacaxi', 5, 34.9
exec CadastrarSuco '300mLMEL', 'Melancia', 0.3, 6.9
exec CadastrarSuco '1LMEL', 'Melancia', 1, 10.9
exec CadastrarSuco '15LMEL', 'Melancia', 1.5, 15.9
exec CadastrarSuco '5LMEL', 'Melancia', 5, 34.9
*/

/*CADASTRO PEDIDOS
exec NovoPedidoCliente 0, 0, 'Débito', 0
exec AdicionarSucoAoPedido 0, '1LL', 1
exec AdicionarSucoAoPedido 0, '15LMEL', 1

exec NovoPedidoCliente 2, 1, 
*/


select * from cliente