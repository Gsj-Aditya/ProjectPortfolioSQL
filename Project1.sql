/*

Covid 19 Data Exploration 
Skills used: Joins, Temp Tables, Aggregate Functions, Creating Views, Converting Data Types

*/

select * from PortfolioProject..coviddeaths
order by 3,4


select * from PortfolioProject..covidvaccinations
order by 3,4

--Select data that we will be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..coviddeaths
order by 1,2


-- Looking at the Total Cases vs Total Deaths

select location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as Ratio_Of_Deaths_to_Cases
from PortfolioProject..coviddeaths
where location like '%India%'
order by 1,2,5.


-- Looking at the Total Cases vs Population
-- Helps in Finding the percentage of population suffered from covid

select location, date, total_cases, population,
(total_cases/population)*100 as Ratio_Of_Cases_to_Population
from PortfolioProject..coviddeaths
where location like '%India%'
order by 1,2,5

-- Looking at countries with Highest Infection Rate Vs Population

select location, MAX(total_cases) as Highest_Infection_Count, population,
MAX(total_cases/population)*100 as Percent_of_Population_Infected
from PortfolioProject..coviddeaths
Group By location, population
order by Percent_of_Population_Infected desc

-- Looking at countries with Highest Death Count per Location
-- Grouping by Location

select location, MAX(cast(total_deaths as int)) as Highest_Total_Death_Count
from PortfolioProject..coviddeaths where continent is not null
Group By location
order by Highest_Total_Death_Count desc



-- Looking at countries with Highest Death Count per Continent
-- Grouping by Continent

select continent, MAX(cast(total_deaths as int)) as Highest_Total_Death_Count
from PortfolioProject..coviddeaths where continent is not null
Group By continent
order by Highest_Total_Death_Count desc

-- Joining Two Tables in the Database

Select * from  PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccinations vac
on dea.location = vac.location and dea.date = vac.date


-- Looking at Total Population vs Vaccinations, as the count of location starts fresh from every new location

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,  
SUM(Convert(bigint,vac.new_vaccinations)) Over(partition by dea.location) 
from  PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Creating a temp table and inserting data

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(300),
Location nvarchar(300),
Date datetime,
Population bigint,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population,
SUM(Convert(bigint,vac.new_vaccinations)) Over(partition by dea.location) as RollingPeopleVaccinated
from  PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select *,(RollingPeopleVaccinated/population)*100 as Ratio from #PercentPopulationVaccinated


--- Creating a View for Visualization in Tableau
Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,
SUM(Convert(bigint,vac.new_vaccinations)) Over(partition by dea.location) as RollingPeopleVaccinated
from  PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null



