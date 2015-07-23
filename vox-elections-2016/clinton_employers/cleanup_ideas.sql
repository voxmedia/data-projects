ALTER TABLE clinton_employers_grouped
ADD cleaning VARCHAR(255);

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, '.', '');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, "'", '');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, 'LLP', ' ');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, 'PLLC', ' ');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, ' INC ', ' ');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, 'LLC', ' ');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, ' AND CO ', ' ');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, ' INC ', ' ');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, ' ET AL ', ' ');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, ' CORPORATION ', ' ');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, ' CORP ', ' ');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, ' CORPORATE ', ' ');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, '"', '');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, ',', '');

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, '&', '');

UPDATE clinton_employers_grouped
SET cleaning = TRIM(cleaning);

UPDATE clinton_employers_grouped
SET cleaning = REPLACE(cleaning, '  ', ' ');
