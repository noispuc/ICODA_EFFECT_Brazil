-- CREATE TABLE srag_simple

DROP TABLE IF EXISTS srag_simple;

CREATE TABLE srag_simple AS
SELECT 
      TO_DATE(TRIM('DT_NOTIFIC'),'DD/MM/YYYY') as notification_date,
	  TRIM('SEM_NOT') as notification_week,
      TO_DATE(TRIM('DT_SIN_PRI'),'DD/MM/YYYY') as symptoms_date,
	  TRIM('SEM_PRI') as symptoms_week,
      TRIM('SG_UF_NOT') as notification_state,
      TRIM('CS_SEXO') as gender, 
          CASE
        	WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 5  THEN '0-4'
        	WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 10 THEN '5-9'
			WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 15 THEN '10-14'
        	WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 20 THEN '15-19'
        	WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 30 THEN '20-29'
        	WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 40 THEN '30-39'
        	WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 50 THEN '40-49'
        	WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 60 THEN '50-59'
        	WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 70 THEN '60-69'
        	WHEN CAST(NULLIF(paciente_idade, '') AS numeric) < 80 THEN '70-79'
        	ELSE '80+'
        END AS age_group,
        CASE
            when cast(CS_RACA as varchar) = '1' THEN 'White'
			WHEN cast(CS_RACA as varchar)  = '2' THEN 'Black'
			WHEN cast(CS_RACA as varchar) = '3' THEN 'Asiam'
			WHEN cast(CS_RACA as varchar) = '4' THEN 'Brown'
			WHEN cast(CS_RACA as varchar)  = '5' THEN 'Indigenous'
            ELSE 'not_informed'
        END AS race, 
	    CASE
            WHEN cast(CS_ESCOL_N as varchar) = '0' THEN 'illiterate'
			WHEN cast(CS_ESCOL_N as varchar) = '1' THEN 'elementary_school'
			WHEN cast(CS_ESCOL_N as varchar) = '2' THEN 'primary_education'
			WHEN cast(CS_ESCOL_N as varchar) = '3' THEN 'secondary_education'
			WHEN cast(CS_ESCOL_N as varchar) = '4' THEN 'tertiary_education'
            ELSE 'not_informed'
        END AS schooling, 
	    CASE
            WHEN FEBRE = 1 THEN 1
            ELSE 0
        END AS fever,	
        CASE
            WHEN cast(TOSSE as varchar) = 1 THEN 1
            ELSE 0
        END AS cough,
	    CASE
            WHEN cast(GARGANTA as varchar) = 1 THEN 1
            ELSE 0
        END AS sore_throat,
	    CASE
            WHEN cast(DISPNEIA as varchar) = 1 THEN 1
            ELSE 0
        END AS dyspnea,
        CASE
            WHEN DESC_RESP = 1 THEN 1
            ELSE 0
        END AS respiratory_distress,
        CASE
            WHEN SATURACAO = 1 THEN 1
            ELSE 0
        END AS saturation,
        CASE
            WHEN DIARREIA = 1 THEN 1
            ELSE 0
        END AS diarrhea,
	    CASE
            WHEN VOMITO  = 1 THEN 1
            ELSE 0
        END AS vomit,
	    CASE
            WHEN OUTRO_SIN = 1 THEN 1
            ELSE 0
        END AS other_symptoms,
	    CASE
            WHEN trim(FATOR_RISC) = 'S' THEN 1
            ELSE 0
        END AS risk_factor,
	    CASE
            WHEN CARDIOPATI = 1 THEN 1
            ELSE 0
        END AS heart_disease,
	    CASE
            WHEN HEMATOLOGI = 1 THEN 1
            ELSE 0
        END AS hematological_disease,
        CASE
            WHEN SIND_DOWN = 1 THEN 1
            ELSE 0
        END AS down_syndrome,
	    CASE
            WHEN HEPATICA  = 1 THEN 1
            ELSE 0
        END AS liver_disease,
        CASE
            WHEN ASMA = 1 THEN 1
            ELSE 0
        END AS asthma,
	    CASE
            WHEN DIABETES  = 1 THEN 1
            ELSE 0
        END AS diabetes,
	    CASE
            WHEN NEUROLOGIC = 1 THEN 1
            ELSE 0
        END AS neurological_disease,
	    CASE
            WHEN PNEUMOPATI = 1 THEN 1
            ELSE 0
        END AS lung_disease,
	    CASE
            WHEN IMUNODEPRE = 1 THEN 1
            ELSE 0
        END AS immunosuppression,
	    CASE
            WHEN RENAL = 1 THEN 1
            ELSE 0
        END AS kidney_disease,
	    CASE
            WHEN OBESIDADE = 1 THEN 1
            ELSE 0
        END AS obesity,
	    CASE
            WHEN OUT_MORBI as varchar = 1 THEN 1
            ELSE 0
        END AS others_comorbidities,
	    CASE
            WHEN UTI = 1 THEN 1
            ELSE 0
        END AS icu,
	    TO_DATE(TRIM(DT_EVOLUCA),'YYYY-MM-DD') as outcome_date,
	    CASE
            WHEN CAST(TRIM(EVOLUCAO) AS VARCHAR) = '1' THEN 'Discharge'
			WHEN CAST(TRIM(EVOLUCAO) AS VARCHAR) = '2' THEN 'Death'
            ELSE 'not_informed'
        END AS outcome 
 
       	FROM srag_bruto;
       

select * from srag_bruto ;