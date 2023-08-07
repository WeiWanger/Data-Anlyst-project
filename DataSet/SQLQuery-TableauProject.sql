/*
  Queries used for Tableau Porject

*/

--1.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2

--2
select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
and location not in ('world','European Union', 'International')
group by location
order by TotalDeathCount desc

--3
Select location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
group by location, population
order by PercentPopulationInfected desc

--4
select location,population,date,MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
Group by Location, population, date
order by PercentPopulationInfected desc