SELECT *
FROM individual_contributions
WHERE cmte_id = "C00579458" AND
    (employer="U S DEPARTMENT OF STATE" OR
    employer="UNITED STATES DEPARTMENT OF JUSTICE" OR
    employer="UNITED STATES DISTRICT COURT" OR
    employer="UNITED STATES GOVERNMENT" OR
    employer="US ARMY" OR
    employer="US CHAMBER" OR
    employer="US CHAMBER OF COMMERCE" OR
    employer="US DEPARTMENT OF STATE" OR
    employer="OFFICE ATTORNEY GENERAL" OR
    employer="DEPARTMENT OF ARMY" OR
    employer="DEPARTMENT OF DEFENSE" OR
    employer="DEPT OF ARMY" OR
    employer="EEOC" OR
    employer="FEDERAL GOVERNMENT" OR
    employer="FEDERAL GOVERNMENT DSS" OR
    employer="US GOVERNMENT" OR
    employer="US HOUSE OF REPRESENTATIVES")
GROUP BY name, left(zip_code, 5)