drop table if exists populacao_municipio_2020;

CREATE TABLE populacao_municipio_2020 (
	cod_ibge int4 NULL,
	nome varchar(200) NULL,
	sexo varchar(10) NULL,
	idade_grupo varchar(20) NULL,
	population int4 NULL,
	uf varchar(10) NULL
);


-- Import data
copy populacao_municipio_2020
from 'D:\Databases\Populacao_Municipio\populacao_municipio_2020.csv'
with null as '' delimiter ',' 
csv header;