--Versão do banco de dados: 20190729


--Criar a banco de dados
/*
CREATE DATABASE abda4
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

ALTER DATABASE bd2a3 SET datestyle TO 'ISO, DMY';
*/

--Dropando a base
-- drop table devedor;
-- drop table depositante;
-- drop table conta;
-- drop table emprestimo;
-- drop table clientecor;
-- drop table agencia;
-- drop table item_pedido;
-- drop table produto;
-- drop table pedido;
-- drop table vendedor;
-- drop table cliente;
-- drop table historico;
-- drop table turma;
-- drop table instrutor;
-- drop table curso;
-- drop table aluno;
-- drop table versao;



--Versão
create table versao (
ver_id serial,
ver_codigo char(8),
ver_data date,
constraint pk_versao primary key (ver_id));

insert into versao values (default, '20190729', '29/07/2019');

--Agencia
create table agencia(
cod_age    integer not null,
nome_age   varchar(40),
cidade_age varchar(40),
fundos_age numeric(10,2),
constraint pk_agencia primary key (cod_age));


--Cliente
create table clientecor(
cod_cli    integer not null,
nome_cli   varchar(40),
rua_cli    varchar(40),
cidade_cli varchar(30),
constraint pk_clientecor primary key (cod_cli));

--Emprestimo 
create table emprestimo(
cod_age_emp	  integer not null,
numero_emp 	  varchar(10) not null,
valor_emp	  numeric(10,2),
constraint pk_emprestimo primary key (cod_age_emp, numero_emp));

alter table emprestimo add constraint fk_emp_agencia foreign key(cod_age_emp)
references agencia;

--Devedor 
create table devedor (
cod_cli_dev	    integer not null,
cod_age_emp_dev     integer not null,
numero_emp_dev	    varchar(10) not null,
constraint pk_devedor primary key (cod_cli_dev, cod_age_emp_dev,
numero_emp_dev));

alter table devedor add constraint fk_dev_cli 
  foreign key(cod_cli_dev) references clientecor;

alter table devedor add constraint fk_dev_emprest 
  foreign key(cod_age_emp_dev,numero_emp_dev) references emprestimo;

--Conta 
create table conta(
cod_age_con	integer not null,
numero_con	varchar(10) not null,
saldo_con	numeric(10,2),
constraint pk_conta primary key (cod_age_con,numero_con));

alter table conta add constraint fk_conta_agencia foreign key(cod_age_con) 
  references agencia;

--Depositante 
create table depositante(
cod_cli_dep	integer not null,
cod_age_con_dep	integer not null,
numero_con_dep	varchar(10) not null,
constraint pk_depositante primary
key(cod_cli_dep,cod_age_con_dep,numero_con_dep));

alter table depositante add constraint fk_dep_cli 
  foreign key(cod_cli_dep) references clientecor;

alter table depositante add constraint fk_dep_conta
  foreign key(cod_age_con_dep,numero_con_dep) references conta;

--INSERTS

--Agencia 

insert into agencia
values (1,'Macedônia','Macedônia', 500000); 

insert into agencia
values (2,'Vila Neri','São Carlos', 1600000); 

insert into agencia
values (3,'Anhagabahú','São Paulo', 5000000); 

insert into agencia
 values (4,'Centro','Araraquara', 300000); 

--Cliente 
insert into clientecor
values (1, 'Jones', 'Main','São Carlos');

insert into clientecor
values (2, 'Smith', 'North','Araraquara');

insert into clientecor
values (3, 'Turner', 'Putman','Votuporanga');

insert into clientecor
values (4, 'Adams', 'Spring', 'Araraquara');

insert into clientecor
values (5, 'Johnson', 'Alma', 'Palo Alto');

insert into clientecor
values (6, 'Hayes', 'Main', 'Harrison');

insert into clientecor
values (7, 'Williams', 'Nassau', 'Princeton');



--Conta 
insert into conta
values (1,'A-101',500);

insert into conta
values (2,'A-215',700);

insert into conta
values (3,'A-102',400);

insert into conta
values (4,'A-201',900);

insert into conta
values (4,'A-217',750);


--Depositante 
insert into depositante
values (5, 1,'A-101');

insert into depositante
values (2, 2,'A-215');

insert into depositante
values (6, 3,'A-102');

insert into depositante
values (5, 4, 'A-201');

insert into depositante
values (1, 4, 'A-217');

--Emprestimo 
insert into emprestimo
values (1,'L-17',1000);

insert into emprestimo
values (3,'L-15',1500);

insert into emprestimo
values (1,'L-14',1500);

insert into emprestimo
values (2,'L-93',500);

insert into emprestimo
values (3,'L-16',1300);

----Devedor 
insert into Devedor
values (1,1,'L-17');

insert into Devedor
values (6,3,'L-15');

insert into Devedor
values (7,2,'L-93');

insert into Devedor
values (1,3,'L-16');

insert into Devedor
values (4,3,'L-15');

-----------------------------------------------------------------------------------
-- Tabela Cliente 
create table cliente (
codigo_cliente numeric(5) not null,
nome_cliente varchar(40),
endereco varchar(40),
cidade varchar(20),
cep varchar(9),
uf char(2),
cnpj varchar(20),
ie varchar(20));

alter table cliente add constraint pk_cliente primary key (codigo_cliente);

-- Tabela vendedor 
create table vendedor (
codigo_vendedor numeric(5) not null,
nome_vendedor varchar(40) not null,
salario_fixo numeric(7,2),
faixa_comissao char(1),
senha varchar(50));

alter table vendedor add constraint pk_vendedor primary key (codigo_vendedor);


-- Tabela pedido
--Note: Uma vez que a tabela pedido faz referencia as tabelas CLIENTE e
--VENDEDOR, eu a
--criei depois de criar as tabelas referenciadas 
 

create table pedido(
num_pedido numeric(5) not null,
prazo_entrega numeric(3) not null,
codigo_cliente numeric(5) not null,
codigo_vendedor numeric(5) not null,
total_pedido    numeric(10,2),
data_pedido date );

alter table pedido add constraint pk_pedido primary key (num_pedido);

alter table pedido add constraint fk_pedido_cliente foreign key
(codigo_cliente)
                                              references cliente; 

alter table pedido add constraint fk_pedido_vendedor foreign key
(codigo_vendedor)
                                              references vendedor; 


                                              
--Tabela produto 
create table produto (
codigo_produto numeric(5) not null,
unidade char(3),
descricao varchar(30),
valor_venda  numeric(7,2),
valor_custo numeric(7,2),
qtde_minima numeric(5,2),
quantidade numeric (5,2),
comissao_produto numeric(5,3)
);

alter table produto add constraint pk_produto primary key (codigo_produto);



-- Tabela Item_Pedido
--Note: mesmo caso da tabela pedido 
 

create table item_pedido (
num_pedido numeric(5) not null,
codigo_produto numeric(5) not null,
quantidade numeric(3),
valor_venda numeric(7,2),
valor_custo numeric(7,2));

alter table item_pedido add constraint pk_item_pedido primary key
(num_pedido,codigo_produto);

alter table item_pedido add constraint fk_item_ped_pedi foreign key
(num_pedido)
                                              references pedido;
alter table item_pedido add constraint fk_item_ped_prod foreign key
(codigo_produto)
                                              references produto;


-- Fim das tabelas 

--Inserido dados na tabela cliente

insert into cliente 
  values (720, 'Ana', 'Rua 17 n. 19', 'Niteroi', '24358310', 'RJ',
'12113231/0001-34', '2134');

insert into cliente
  values (870, 'Flávio', 'Av. Pres. Vargas 10', 'São Paulo', '22763931', 'SP',
'22534126/9387-9', '4631');

insert into cliente
  values (110, 'Jorge', 'Rua Caiapo 13', 'Curitiba', '30078500', 'PR',
'14512764/9834-9', null);

insert into cliente 
  values (222, 'Lúcia', 'Rua Itabira 123 Loja 9', 'Belo Horizonte',
'221243491', 'MG', '28315213/9348-8', '2985');

insert into cliente 
  values (830, 'Maurício', 'Av. Paulista 1236', 'São Paulo', '3012683', 'SP',
'32816985/7465-6', '9343');

insert into cliente 
  values (130, 'Edmar', 'Rua da Praia sn', 'Salvador', '30079300', 'BA',
'23463284/234-9', '7121');

insert into cliente
  values (410, 'Rodolfo', 'Largo da lapa 27 sobrado', 'Rio de Janeiro',
'30078900', 'RJ', '12835128/2346-9', '7431');

insert into cliente 
  values (20, 'Beth', 'Av. Climério n.45', 'São Paulo', '25679300', 'SP',
'3248126/7326-8', '9280');

insert into cliente
  values (157, 'Paulo', 'T. Moraes c/3', 'Londrina', null, 'PR',
'3284223/324-2', '1923');

insert into cliente
  values (180, 'Lúcio', 'Av. Beira Mar n. 1256', 'Florianópolis', '30077500',
'SC', '12736571/2347', null);

insert into cliente 
  values (260, 'Susana', 'Rua Lopes Mendes 12', 'Niterói', '30046500', 'RJ',
'21763571/232-9', '2530');

insert into cliente 
  values (290, 'Renato', 'Rua Meireles n. 123 bl. sl.345', 'São Paulo',
'30225900', 'SP', '13276547/213-3', '9071');

insert into cliente 
  values (390, 'Sebastião', 'Rua da Igreja n.10', 'Uberaba', '30438700', 'MG',
'32176547/213-3', '9071');

insert into cliente 
  values (234, 'José', 'Quadra 3 bl. 3 sl. 1003', 'Brasilia', '22841650', 'DF',
'21763576/1232-3', '2931');

insert into cliente 
  values (500, 'Rodolfo', 'Largo do São Francisco 27 sobrado', 'São Paulo', '82679330', 'SP', '6248125/3321-7', '1290');

--inserido dados na tabela Vendedor

insert into vendedor
  values (209, 'José', 1800.00, 'C', null);

insert into vendedor
  values (111, 'Carlos', 2490.00, 'A', null);

insert into vendedor
  values (11, 'João', 2780.00, 'C', null);

insert into vendedor
  values (240, 'Antônio', 9500.00, 'C', null);

insert into vendedor
  values (720, 'Felipe', 4600.00, 'A', null);

insert into vendedor
  values (213, 'Jonas', 2300.00, 'A', null);

insert into vendedor
  values (101, 'João', 2650.00, 'C', null);

insert into vendedor
  values (310, 'Josias', 870.00, 'B', null);

insert into vendedor
  values (250, 'Maurício', 2930.00, 'B', null);

--Inserido dados na tabela Pedido
--Nota: So podemos inserir dados nesta tabela, depois de inserir dados nas
--tabelas Cliente e Vendedor

insert into pedido
  values (121,20,410,209, null, '24/09/2017');

insert into pedido
  values (97,20,720,101, null, '24/09/2017');

insert into pedido
  values (101,15,720,101, null, '12/03/2019');

insert into pedido
  values (137,20,720,720, null, '27/11/2018');

insert into pedido
  values (148,20,720,101, null, '08/07/2018');

insert into pedido
  values (189,15,870,213, null, '14/03/2019');

insert into pedido
  values (104,30,110,101, null, '19/08/2018');

insert into pedido
  values (203,30,830,250, null, '01/02/2018');

insert into pedido
  values (98,20,410,209, null, '06/04/2019');

insert into pedido
  values (143,30,20,111, null, '12/03/2019');

insert into pedido
  values (105,15,180,240, null,'03/11/2018');

insert into pedido
  values (111,20,260,240, null,'04/07/2017');

insert into pedido
  values (103,20,260,240, null,'01/02/2018');

insert into pedido
  values (91,20,260,11, null,'01/02/2018');

insert into pedido
  values (138,20,260,11, null,'01/02/2018');

insert into pedido
  values (108,15,290,310, null,'01/02/2018');

insert into pedido
  values (119,30,390,250, null,'01/02/2018');

insert into pedido
  values (127,10,410,11, null,'01/02/2018');


--Inserido dados na tabela Produto

insert into produto
  values (25,'Kg','Queijo',5.97, null, null, null, null);

insert into produto
  values (31,'BAR','Chocolate',5.87, null, null, null, null);

insert into produto
  values (78,'L','Vinho', 7, null, null, null, null);

insert into produto
  values (22,'M','Tecido',5.11, null, null, null, null);

insert into produto
  values (30,'SAC','Açúcar',5.30, null, null, null, null);

insert into produto
  values (53,'M','Linha',6.80, null, null, null, null);

insert into produto
  values (13,'G','Ouro',11.18, null, null, null, null);

insert into produto
  values (45,'M','Madeira',5.25, null, null, null, null);

insert into produto
  values (87,'M','Cano',6.97, null, null, null, null);

insert into produto
  values (77,'M','Papel',6.05, null, null, null, null);




--Inserido dados na tabela Item_Pedido
--Nota: So podemos inserir dados nesta tabela, depois de inserir dados nas
--tabelas Pedido e Produto*/

insert into item_pedido
  values (101,78,18, null, null);

insert into item_pedido
  values (101,13,5, null, null);

insert into item_pedido
  values (98,77,5, null, null);

insert into item_pedido
  values (148,45,8, null, null);

insert into item_pedido
  values (148,31,7, null, null);

insert into item_pedido
  values (148,77,3, null, null);

insert into item_pedido
  values (148,25,10, null, null);

insert into item_pedido
  values (148,78,30, null, null);

insert into item_pedido
  values (104,53,32, null, null);

insert into item_pedido
  values (203,31,6, null, null);

insert into item_pedido
  values (189,78,45, null, null);

insert into item_pedido
  values (143,31,20, null, null);

insert into item_pedido
  values (105,78,10, null, null);

insert into item_pedido
  values (111,25,10, null, null);

insert into item_pedido
  values (111,78,70, null, null);

insert into item_pedido
  values (103,53,37, null, null);

insert into item_pedido
  values (91,77,40, null, null);

insert into item_pedido
  values (138,22,10, null, null);

insert into item_pedido
  values (138,77,35, null, null);

insert into item_pedido
  values (138,53,18, null, null);

insert into item_pedido
  values (108,13,17, null, null);

insert into item_pedido
  values (119,77,40, null, null);

insert into item_pedido
  values (119,13,6, null, null);

insert into item_pedido
  values (119,22,10, null, null);

insert into item_pedido
  values (119,53,43, null, null);

insert into item_pedido
  values (137,13,8, null, null);

-- Fim inserts 

-- Confirmando alterações 

commit;


------Banco de dados acadêmico -----------------------

CREATE TABLE Instrutor (
  inst_codigo numeric(5)   NOT NULL ,
  inst_nome varchar(40)    ,
  inst_telefone varchar(15)    ,
  inst_dataadmissao DATE      ,
PRIMARY KEY(inst_codigo));


/*Inserindo Instrutores */
insert into Instrutor
 values (1, 'Maria Carolina', '344-8788', '1/2/2017');
  
insert into Instrutor
  values (2, 'Pedro Paula', '274-9018', '8/3/2016');
  
insert into Instrutor
  values (3, 'Augusto Lemos', '722-1300', '12/11/2017');
  
insert into Instrutor
  values (4, 'Monica Silveira', '212-7938', '30/11/2017');

commit;


----Tabela Curso ---------------

CREATE TABLE Curso (
  cur_Cod numeric(5)   NOT NULL ,
  cur_Nome VARCHAR(40)    ,
  cur_CargaHoraria numeric(5,2)    ,
  cur_ValorCurso numeric(7,2)    ,
  cur_PreRequisito numeric(5)      ,
PRIMARY KEY(cur_Cod));


/*Inserindo curso */
insert into Curso
 values (1, 'Introducao a Logica de Programação', 32, 800, null); 
insert into Curso
 values (2, 'Fundamentos de Modelagem de Dados', 40, 950, null); 
insert into Curso
 values (3, 'Redes I',40 ,1200 , null); 
insert into Curso
 values (4, 'Introducao a Sistemas Operacionais', 32 ,670 , null); 
insert into Curso
 values (5, 'Análise Orientada por Objetos',40 ,890 , null);
insert into Curso
 values (6, 'Delphi:Recurso Basicos', 24,400 , 1);
insert into Curso
 values (7, 'Delphi: Acesso a Banco de Dados',24 ,400, 1);
insert into Curso
 values (8, 'Oracle:SQL*PLUS e SQL', 32,750 , null);
insert into Curso
 values (9, 'Oracle:PL/SQL', 24, 750, null);
insert into Curso
 values (10, 'Redes II', 32,1000 , 3);


CREATE TABLE Aluno (
  alu_Matricula numeric(5)   NOT NULL ,
  alu_Nome varchar(40)    ,
  alu_Tel varchar(15)    ,
  alu_Ender varchar(40)    ,
  alu_Cidade varchar(30)    ,
  alu_UF CHAR(2)    ,
  alu_DataNascimento DATE      ,
PRIMARY KEY(alu_Matricula));


/*Inserindo Alunos */
insert into Aluno
 values (1, 'Marcos Silva Hydra', '3474-2318', 'R. Adolfo Lutz, 27/902', 'São Paulo', 'SP', '10/03/2003');
insert into Aluno
 values (2, 'Otávio Ramos Oliveira', '399-1490', 'R. Albert Einsten, 13', 'Votuporanga', 'SP', '12/05/2003');
insert into Aluno
 values (3, 'Wellington Machado', '655-1138', 'Av. do Contorno', 'Linhares', 'ES', '10/08/2004');
insert into Aluno
 values (4, 'Tadeu Mauro Alencar', '311-4671', 'T. Orquideas', 'Barbacena', 'MG' ,'05/02/2004');
insert into Aluno
 values (5, 'Luis Firmino Rios', '211-6600', 'Av. Conceicao Silva', 'Uberaba', 'MG', '19/07/2005');
 insert into Aluno
 values (6, 'Ademar Silveira Barros', '6588-6600', 'Rua das Acácias', 'Votuporanga', 'SP', '27/11/2005');

commit;




CREATE TABLE Turma (
  tur_CodTur numeric(5)   NOT NULL ,
  tur_CodigoCurso numeric(5)   NOT NULL ,
  tur_CodigoInstrutor numeric(5)   NOT NULL ,
  tur_PrecoHoraTur NUMERIC(4,2)    ,
  tur_SalaTur INTEGER      ,
PRIMARY KEY(tur_CodTur),
  FOREIGN KEY(tur_CodigoCurso)  REFERENCES Curso,
  FOREIGN KEY(tur_CodigoInstrutor)  REFERENCES Instrutor);


/*Inserindo Turmas*/
insert into Turma
 values (1,1,1,20,2);
insert into Turma
 values (2,1,2,20,5);
insert into Turma
 values (3,2,3,25,4);
insert into Turma
 values (4,3,4,20,4);
insert into Turma
 values (5,3,3,20,6);
insert into Turma
 values (7,7,3,25,1);
insert into Turma
 values (8,5,4,40,8);

commit;

CREATE TABLE Historico (
  hist_Matriculaaluno numeric(5)   NOT NULL ,
  hist_CodigoTurma numeric(5)   NOT NULL ,
  hist_NotaBim1 numeric(3,1)    ,
  hist_NotaBim2 numeric(3,1)    ,
  hist_Presenca numeric(3,1)      ,
PRIMARY KEY(hist_Matriculaaluno, hist_CodigoTurma),
  FOREIGN KEY(hist_Matriculaaluno)   REFERENCES Aluno,
  FOREIGN KEY (hist_CodigoTurma) REFERENCES Turma);


/*Inserindo Historico*/
insert into Historico
 values (1,1,7.5, 7.0, 50);
insert into Historico
 values (5,2,7, 6.0, 70);
insert into Historico
 values (1,5,6, 6.0, 80);
insert into Historico
 values (1,4,9, 8.5, 75);
insert into Historico
 values (4,2,3, 4.0, 90);
insert into Historico
 values (3,2,5.5, 5.5, 80);

commit;




-------Fim Banco de dados acadêmico

--Realizando as alterações no banco de dados após ele ser instalado


--Adicionando campo de senha na tabela vendedor



update produto
set quantidade =  10;

update produto
set qtde_minima =  5;

update produto
set valor_custo =  3;



update item_pedido ip
	set valor_custo = (select valor_custo
								from produto p
							  where ip.codigo_produto = p.codigo_produto),
		 valor_venda = (select valor_venda
								from produto p
							  where ip.codigo_produto = p.codigo_produto);


update produto
set comissao_produto = 0.005;



--Atualizando o valor total de pedidos
update pedido pe
	set total_pedido = (select sum((quantidade* valor_venda))
							 	 from item_pedido ip
							  	where ip.num_pedido  = pe.num_pedido
							 	group by ip.num_pedido );


-- Salvando os Dados 

commit;

-----------------------------------------------------------------------------------
--View

create table alunov (
id integer not null,
ra varchar(10) not null, 
nome varchar(40) not null, 
ender varchar(40) not null, 
cidade varchar(40) not null
);

create table aluno_grad (
id integer not null,
ano_curso varchar(20) not null
);

create table aluno_pos (
id integer not null,
orientador varchar(20)
);

create table cursa (
cursa_alu_id integer not null, 
cursa_alu_discip integer not null, 
cursa_nota1 numeric(6,2), 
cursa_nota2 numeric(6,2), 
cursa_nota3 numeric(6,2), 
cursa_nota4 numeric(6,2)
);

create table discip (
disc_id integer not null,
disc_codigo varchar(5) not null,
disc_descricao varchar(20)
);


insert into alunov
values (1, 'RA1', 'João', 'Rua A', 'Votuporanga');

insert into alunov
values (2, 'RA2', 'Pedro', 'Rua XX', 'Votuporanga');

insert into alunov
values (3, 'RA41', 'José', 'Rua YY', 'Macedônia');

insert into aluno_grad
values (2, 'ano3');

insert into aluno_grad
values (1, 'ano2');

insert into aluno_pos
values (3, 'Manoel');

insert into discip
values (1, 'D1', 'Banco de Dados');

insert into discip
values (2, 'D2', 'Estrutura de Dados');

insert into cursa
values (1, 1, 5,6,8,3);

insert into cursa
values (1, 2, 6,6,6,6);

insert into cursa
values (1, 3, 10,6,8,10);

insert into cursa
values (2, 1, 6,1,8,10);

insert into cursa
values (2, 2, 2,2,6,7.5);



-- Fim 
