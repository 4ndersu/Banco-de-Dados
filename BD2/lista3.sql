--q1
select * from aluno
where genero = 'Feminino' and anoentrada = 2023;

--q2
select count(*) from aluno
where anoentrada = 2022 and codcurso = 1

--q3
select count(*) from curso
where ch = 60

--q4
select * from aluno
where nome ilike '%Silva' and anoentrada = 2022

--q5
select count(*) from aluno
where anoentrada = 2021 and genero = 'Masculino'


--Tipo money :: converter para numerico 1000::Money ou :: depois do campo where ::NUMERIC
