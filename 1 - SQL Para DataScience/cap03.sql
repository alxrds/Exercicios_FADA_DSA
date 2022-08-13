CREATE TABLE cap03.TB_DADOS2
SELECT 
	CASE 
		WHEN classe = 'no-recurrence-events' THEN 0
        WHEN classe = 'recurrence-events' THEN 1
	END classe_bin, idade, menopausa, 
    CASE 
		WHEN tamanho_tumor = '0-4' OR tamanho_tumor = '5-9' THEN 'Muito Pequeno'
        WHEN tamanho_tumor = '10-14' OR tamanho_tumor = '15-19' THEN 'Pequeno'
        WHEN tamanho_tumor = '20-24' OR tamanho_tumor = '25-29' THEN 'Médio'
        WHEN tamanho_tumor = '30-34' OR tamanho_tumor = '35-39' THEN 'Grande'
        WHEN tamanho_tumor = '40-44' OR tamanho_tumor = '45-49' THEN 'Muito Grande'
        WHEN tamanho_tumor = '50-54' OR tamanho_tumor = '55-59' THEN 'Tratamento Urgente'
	END tamanho_tumor_cat, inv_nodes, 
    CASE 
		WHEN node_caps = 'no' THEN 0
        WHEN node_caps = 'yes' THEN 1
        ELSE 2
	END node_caps_bin, deg_malig, 
    CASE 
		WHEN seio = 'left' THEN 'E'
        WHEN seio = 'right' THEN 'D'
    END seio_cat, 
    CASE 
		WHEN quadrante = 'left_low' THEN 1
        WHEN quadrante = 'right_up' THEN 2
        WHEN quadrante = 'left_up' THEN 3
        WHEN quadrante = 'right_low' THEN 4
        WHEN quadrante = 'central' THEN 5
        ELSE 0
	END quadrante_cat,
	CASE 
		WHEN irradiando = 'no' THEN 0
        WHEN irradiando = 'yes' THEN 1
	END irradiano_bin
FROM cap03.TB_DADOS;

#1- Aplique label encoding à variável menopausa.
SELECT  
	CASE 
		WHEN menopausa = 'premeno' THEN 1
        WHEN menopausa = 'ge40' THEN 2
        WHEN menopausa = 'lt40' THEN 3
	END menopausa_cat
FROM cap03.TB_DADOS;

#2- [Desafio] Crie uma nova coluna chamada posicao_tumor concatenando as colunas inv_nodes e quadrante.
SELECT CONCAT(inv_nodes, '-', quadrante) posicao_tumor 
FROM cap03.TB_DADOS;

#3- [Desafio] Aplique One-Hot-Encoding à coluna deg_malig.
SELECT 
CASE WHEN deg_malig = 1 THEN 1 ELSE 0 END deg_malig_1,
CASE WHEN deg_malig = 2 THEN 1 ELSE 0 END deg_malig_2,
CASE WHEN deg_malig = 3 THEN 1 ELSE 0 END deg_malig_3
FROM cap03.TB_DADOS;

#4- Crie um novo dataset com todas as variáveis após as transformações anteriores.
CREATE TABLE cap03.TB_DADOS3
	SELECT classe, idade,
    	CASE 
			WHEN menopausa = 'premeno' THEN 1
			WHEN menopausa = 'ge40' THEN 2
			WHEN menopausa = 'lt40' THEN 3
		END menopausa_cat, tamanho_tumor, 
        CONCAT(inv_nodes, '-', quadrante) posicao_tumor,
        CASE WHEN deg_malig = 1 THEN 1 ELSE 0 END deg_malig_1,
		CASE WHEN deg_malig = 2 THEN 1 ELSE 0 END deg_malig_2,
		CASE WHEN deg_malig = 3 THEN 1 ELSE 0 END deg_malig_3,
        seio, irradiando
	FROM cap03.TB_DADOS;
        
