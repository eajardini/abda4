--paciente = {id_paciente, codigo, nome, idade}
create sequence sid_paciente;
create table ec_paciente (
    id_paciente integer,
    codigo varchar(2),
    nome varchar(10),
    idade integer,
    CONSTRAINT pk_paciente PRIMARY KEY (id_paciente)
);

--medico = {id_medico, crm, nome, especialidade}
create sequence sid_medico;
create table ec_medico (
    id_medico integer,
    crm varchar(2),
    nome varchar(10),
    especialidade varchar(10),
    CONSTRAINT pk_medico PRIMARY KEY (id_medico)
);


--atende = {id_atende, id_paciente, id_medico, data}
create sequence sid_atende;
create table ec_atende (
    id_atende integer,
    id_paciente integer,
    id_medico integer,
    data date,
    CONSTRAINT pk_atende PRIMARY KEY (id_atende),
    CONSTRAINT fk_atende_paciente FOREIGN key (id_paciente)
            references ec_paciente,
    CONSTRAINT fk_atende_medico FOREIGN key (id_medico)
            references ec_medico       
);

--cirurgia = {id_cirurgia, codigo, data, descrição, id_paciente}
create sequence sid_cirurgia;
create table ec_cirurgia (
    id_cirurgia integer,
    codigo varchar(2),
    data date,
    descrição varchar(10),   
    id_paciente integer,
    CONSTRAINT pk_cirurgia PRIMARY KEY (id_cirurgia),
    CONSTRAINT fk_cirurgia_paciente FOREIGN key (id_paciente)
            references ec_paciente
);





--Cadastro de paciente
INSERT INTO ec_paciente 
values (nextval('sid_paciente'),'p1', 'João', 12);

--cadastro de medico
INSERT INTO ec_medico
values (nextval('sid_medico'), 'm1', 'marcos', 'oftalmo');

INSERT INTO ec_medico
values (nextval('sid_medico'), 'm2', 'marcia', 'Pediatra');

--cadastro de atendimento

insert into ec_atende 
values (nextval('sid_atende'), (select id_paciente
                                from ec_paciente
                                where codigo = 'p1'),
                                (select id_medico
                                from ec_medico
                                where crm = 'm1')
                                , '12/09/2019');
insert into ec_atende 
values (nextval('sid_atende'), (select id_paciente
                                from ec_paciente
                                where codigo = 'p1'),
                                (select id_medico
                                from ec_medico
                                where crm = 'm2')
                                , '11/09/2019');


id_atende integer,
    id_paciente integer,
    id_medico integer,
    data date,

1) 
--código  do  paciente,  adata  da  cirurgiae  adescrição do procedimento cirúrgico
create OR REPLACE FUNCTION f_criacirurgia(parCodPac varchar,
                                          parDataCirugia date,
                                          parDescricao varchar)
                                          returns void
AS
$$
declare lid_cirurgia INTEGER;
        lid_paciente INTEGER;
        lcod_cirurgia varchar(2);

BEGIN
    select id_paciente into lid_paciente
    from ec_paciente
    where codigo = parCodPac;

    if not found then 
        raise 'O cliente de código % não foi encontrado' , parCodPac using ERRCODE = 'ERR01';        
    end if;

    select nextval('sid_cirurgia') into lid_cirurgia;
    lcod_cirurgia = 'c' || lid_cirurgia;

    INSERT INTO ec_cirurgia
      values (lid_cirurgia, lcod_cirurgia, parDataCirugia, parDescricao, lid_paciente);

end;
$$
language plpgsql;

select f_criacirurgia('p1','09/11/2019', 'Braço');

select * from ec_cirurgia;

2)
-- O desempenho dos médicos é auferido pela quantidade de atendimento que fazem por pe-
-- ríodo. Assim, desenvolva uma função que informadas as datas inicial e final dos atendi-
-- mentos, retorne o nome do médico e a quantidade de atendimento que realizou no período.
-- Retorne tudo isso em forma de registro (returns setof record). Caso o período não retorne
-- nenhuma consulta, deve ser gerado um erro com RAISE e abortar a função. Exemplo: se
--você colocou as datas 01/01/2003 a 31/12/2006, vai retornar Paulo 1; 
                                                         --   Marcos 1.

CREATE OR REPLACE FUNCTION f_RetornaAtendimento(parDataIncial date, 
                                                parDataFinal date)
                                                returns SETOF record
AS
$$
declare regAtende RECORD;

BEGIN
    
    FOR regAtende in
        select med.nome , count(aten.id_medico) 
        from   ec_medico med, ec_atende aten
        where  med.id_medico = aten.id_medico
           and  aten.data >= parDataIncial
           and  aten.data <= parDataFinal
        group by 1
    loop
        return next regAtende;
    end loop;

    if not found then 
        raise 'Não existem atendimentos no período de % a %', parDataIncial,  parDataFinal 
               using ERRCODE = 'ERR01';        
    end if;

    return;
end;
$$
language plpgsql;

select * from f_RetornaAtendimento ('01/06/2019', '30/12/2019')
       as (nome varchar , atendimento BIGINT);

3)

-- É importante realizar verificações de regras de negócio no momento em que dados são alte-
-- rados ou inseridos. Desta forma, desenvolva um trigger que verifique, no momento em que
-- uma cirurgia for inserida, se a data da cirurgia seja igual ou antes da data corrente. Se ela for
-- maior, o trigger não pode deixar que a cirurgia seja inserida.

create or replace function f_verificaDataCadastro() returns trigger
as $$
BEGIN
    if new.data > CURRENT_DATE then 
         raise 'Não é possível fazer cirurgia com data futura' 
               using ERRCODE = 'ERR01'; 
    end if;

return new;
end;
$$ language plpgsql;

create trigger trg_verificaDataCadastro
before insert or update
on ec_cirurgia for each row
execute procedure f_verificaDataCadastro();