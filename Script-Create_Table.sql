use LojaSuco
go

/*TABELAS*/

create table pessoa
(
	id smallint not null,
	nome char(25) not null,
	telefone char(11) not null,
	endereco char(60) not null,
	primary key (id)
)
go

create table cliente
(
	id smallint not null,
	cpf char(11) not null,

	/* Opções de plano mensal: Simples, Especial e Gourmet */
	planoMensal char(8) null default '',

	primary key (id),
	foreign key (id) references pessoa
)
go

create table fornecedor
(
	id smallint not null,
	cnpj char(15) not null,
	
	primary key (id),
	foreign key (id) references pessoa
)
go

create table insumo
(
	id smallint not null,
	nome char(20) not null,

	primary key (id)
)
go

create table item_fornecimento
(
	id smallint not null,
	idInsumo smallint not null,
	idFornecedor smallint not null,
	valor smallmoney not null,

	primary key (id),
	foreign key (idInsumo) references insumo,
	foreign key (idFornecedor) references fornecedor
)
go

create table pedido_fornecedor
(
	id smallint not null,
	dataPedido date not null,
	valorTotal smallmoney not null,

	primary key (id)
)
go

create table compor_insumo
(
	idPedido smallint not null,
	idItemFornecimento smallint not null,
	quantidade smallint not null,

	primary key (idPedido, idItemFornecimento),

	foreign key (idPedido) references pedido_fornecedor,
	foreign key (idItemFornecimento) references item_fornecimento
)
go

create table suco
(
	id char(10) not null,
	sabor char(31) not null,
	tipo char(8) not null,
	/* Em litros */
	tamanho float not null,
	valor smallmoney not null,

	primary key (id)
)
go

create table produz
(
	idInsumo smallint not null,
	idSuco char(10) not null,

	primary key (idInsumo, idSuco),
	foreign key (idInsumo) references insumo,
	foreign key (idSuco) references suco
)
go

create table pedido_cliente
(
	id smallint not null,
	idCliente smallint not null,
	dataPedido date not null,
	isPlanoMensal bit not null,
	formaPagamento char(15) null,
	desconto smallmoney null,
	valorTotal smallmoney not null,

	primary key (id),
	foreign key (idCliente) references cliente
)
go

create table compor_suco
(
	idPedido smallint not null,
	idSuco char(10) not null,
	quantidade smallint not null,

	primary key (idPedido, idSuco),
	foreign key (idPedido) references pedido_cliente,
	foreign key (idSuco) references suco
)
go

/*INDEX*/

create index fkeys_item_fornecimento
on item_fornecimento (idInsumo, idFornecedor)
go

create index fkeys_pedido_cliente
on pedido_cliente (idCliente)
go

/* VIEWS */
create view dadosClientes
as
select pessoa.id, nome, telefone, endereco, cpf, planoMensal from pessoa inner join cliente
	on pessoa.id = cliente.id

create view dadosFornecedores
as
select pessoa.id, nome, telefone, endereco, cnpj from pessoa inner join fornecedor
	on pessoa.id = fornecedor.id

create view clientesPlanoMensal
as
select * from dadosClientes where planoMensal is not null

create view sucosSimples
as
select distinct id, sabor from suco where LOWER(tipo) = 'simples'

create view sucosEspeciais
as
select distinct id, sabor from suco where LOWER(tipo) = 'especial'

create view sucosGourmet
as
select distinct id, sabor from suco where LOWER(tipo) = 'gourmet'

create view itemFornecimento
as
select item_fornecimento.id, idInsumo, insumo.nome as 'nomeProduto', idFornecedor, dadosFornecedores.nome as 'nomeFornecedor', dadosFornecedores.cnpj, valor from item_fornecimento inner join insumo
	on item_fornecimento.idInsumo = insumo.id
	inner join dadosFornecedores
		on item_fornecimento.idFornecedor = dadosFornecedores.id