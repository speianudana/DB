--2. Sa se modifice schema tabelului grupe, ca sa corespunda urmatoarelor cerinte:
--   a) Campul Cod_ Grupa sa accepte numai valorile unice și să nu accepte valori necunoscute.
        ALTER TABLE grupe 
        ADD UNIQUE (Cod_Grupa);

--   b) Să se țină cont că cheie primară, deja, este definită asupra coloanei Id_ Grupa.       
      ALTER TABLE grupe
      ALTER COLUMN Cod_Grupa char(6) NOT NULL;