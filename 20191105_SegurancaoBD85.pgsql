-- Respostas ao exercício da página 85: 
--      Segurança e Usuários


--1)Você ficou ficou encarregado de criar o ambiente para a instalação de um software de controle de processos
-- empresariais denominado SIGASYS. Assim, crie um banco de dados denominado de SIGASYS e execute
-- nele o script da base de dados da disciplina.

create database SIGASYS
encoding 'utf-8';

\i /home/aluno/Aluno/Evandro/2019ABDA4/20190729_criabaseBD_Postgres.sql

--2 a) Criar um usuário denominado ”secretaria” que possui somente o direito de visualizar os dados das
--tabelas de CLIENTE e VENDEDORES. Ela não deverá poder criar, atualizar ou deletar nenhum objeto
--do banco. 
create user secretaria password 'postdba';

grant select on cliente, vendedor to secretaria;

-- 2 b) Criar um usuário denominado vendedor que possui os direitos de atualizar, criar e visualizar os dados
--na tabela de CLIENTE; criar, atualizar, visualizar e apagar dados da tabela de PEDIDO, atualizar, criar
--e visualizar os dados na tabela de ITEM_PEDIDO e atualizar e visualizar dados da tabela PRODUTO.
create user vendedor password 'postdba';
grant select, update, insert, delete on pedido to vendedor;
grant select, update, insert  on item_pedido to vendedor;
grant select, update on produto to vendedor;

--3 c) Criar um usuário gerente podendo visualizar, inserir, atualizar e deletar dados das tabelas do banco de
--dados SIGASYS.
create user gerente password 'postdba';
-- o usuário postges deve estar dentro do BD sigasys
grant ALL PRIVILEGES on ALL TABLES IN SCHEMA PUBLIC to gerente;


