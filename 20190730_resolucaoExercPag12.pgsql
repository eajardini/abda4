1. Crie o modelo físico das relações 
correntista = {cpf, nome, data_nasc, cidade, uf} e 
conta_corrente {num_conta, cpf_correntista (fk), saldo}. 
Garanta as seguintes regras de negócio:
(a) Uma conta corrente só pode ser aberta com saldo mínimo inicial 
de R$ 500,00.
(b) Os correntistas devem ser maiores que 18 anos. 
Para isso, você deve comparar a data de nasci-
mento com a data atual. No Postgres, para saber a 
data atual, use a função ((CURRENT_DATE -
data_nasc)/365>=18) ou use a função AGE(CURRENT_DATE, Data_Nasc) >= '18 Y'


create TABLE correntista (
    cpf varchar(11),
    nome varchar (40),
    data_nasc date,
    cidade varchar(20),
    uf char(2),
    CONSTRAINT pk_correntista PRIMARY KEY (cpf),
    CONSTRAINT ck_idade check (AGE(CURRENT_DATE, data_nasc) >= '18 Y'));

create table conta_corrente (
    num_conta varchar(10),
    cpf_correntista varchar(11), 
    saldo numeric (10,2),
    constraint pk_conta_corrente primary key(num_conta),
    constraint fk_conta_corrente_correntista foreign key(cpf_correntista)
    references correntista,
    constraint ck_saldo_inicial check (saldo >= 500));

