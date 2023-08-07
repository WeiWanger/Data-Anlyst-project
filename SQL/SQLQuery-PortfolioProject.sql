select * 
from 
PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select * 
--from 
--PortfolioProject..CovidVaccinations
--order by 3,4

--select  data that we are going to be using
Select Location, date, total_cases, new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
order by 1,2

--Looking at total_cases VS Total_deaths
select Location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject .. CovidDeaths
where location like '%states%'
order by 1,2

--Looking at total cases Vs Population
--shows percentage of population got Covid
select Location, date, total_cases, population, (total_cases / population)*100 as InffectionRate 
From PortfolioProject..CovidDeaths
where location like '%anada%'
Order by 1,2

--Looking at countries with highest inffection rate compared to population 
select Location,population, max(total_cases) as HighestInfectionCount,  max((total_cases / population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
group by location,population
Order by PercentPopulationInfected desc

--Showing Countries with Highest Death count per Population
select location, max(CAST(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by location
Order by TotalDeathCount desc

--Let's break things dow by continet
select continent, max(CAST(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
Order by TotalDeathCount desc

-- Showing continents with the highest death count per population 
select continent, max(CAST(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global Numbers
select sum(new_cases)as NewCasesCount, sum(CAST(new_deaths as int))as NewDeathsCount, sum(CAST(new_deaths as int))/sum(new_cases)*100 as NewDeathRate 
from PortfolioProject..CovidDeaths
where continent is not null
--group by date 
order by 1 asc 

--The data from Covid Vaccinations
select * 
From PortfolioProject..CovidVaccinations

--Join Query on location 
select * from PortfolioProject..CovidDeaths death 
join PortfolioProject..CovidVaccinations vaccine
on death.location = vaccine.location 
and death.date = vaccine.date

--looking at total population Vs Vaccinations
select death.continent, death.location, death.date, death.population,
vaccine.new_vaccinations
from PortfolioProject..CovidDeaths death 
join PortfolioProject..CovidVaccinations vaccine
ON death.location = vaccine.location
and death.date = vaccine.date

--total count of new vaccine 
select death.continent, death.location, death.date, death.population,
vaccine.new_vaccinations, sum(CAST(vaccine.new_vaccinations as int)) 
Over (Partition by death.location order by death.location, death.date) as RollingVaccinations
from PortfolioProject..CovidDeaths death 
join PortfolioProject..CovidVaccinations vaccine
ON death.location = vaccine.location
and death.date = vaccine.date

--Looking to the rate that rolling number to population
select death.continent, death.location, death.date, death.population,
vaccine.new_vaccinations, sum(CAST(vaccine.new_vaccinations as int)) 
Over (Partition by death.location order by death.location, death.date) as RollingVaccinations
from PortfolioProject..CovidDeaths death 
join PortfolioProject..CovidVaccinations vaccine
ON death.location = vaccine.location
and death.date = vaccine.date

--CTE
with PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccinated)
as
(
select death.continent, death.location, death.date, death.population,
vaccine.new_vaccinations, sum(CAST(vaccine.new_vaccinations as int)) 
Over (Partition by death.location order by death.location, death.date) as RollingVaccinations
from PortfolioProject..CovidDeaths death 
join PortfolioProject..CovidVaccinations vaccine
ON death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null
)
select *, (RollingVaccinated/Population)*100 from PopVsVac

--Temp Table
Drop table if exists  #PercentPopulationVaccinated 
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select death.continent, death.location,death.date, death.population, vaccine.new_vaccinations,
SUM(CAST(vaccine.new_vaccinations as int)) over (partition by death.location order by death.location, death.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths death 
join PortfolioProject..CovidVaccinations vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null

select *, (RollingPeopleVaccinated/population)*100 as PercentPopulationVaccinations
from #PercentPopulationVaccinated

--Create View to store data for later visualizations
create view PercentPopulationVaccinated as 
Select death.continent, death.location,death.date, death.population, vaccine.new_vaccinations,
SUM(CAST(vaccine.new_vaccinations as int)) over (partition by death.location order by death.location, death.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths death 
join PortfolioProject..CovidVaccinations vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null


select * from PercentPopulationVaccinated