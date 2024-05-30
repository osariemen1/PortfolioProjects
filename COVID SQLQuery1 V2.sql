
Select *
From ProjectP..CovidDeaths$
where continent is not null
order by 3,4

-- dates from 01/03/20 - 08/09/2023

--Select *
--From ProjectP..CovidVaccinations$
--order by 3,4

--Select Data we are going to be using 

Select Location, date, total_cases,new_cases, total_deaths, population
From ProjectP..CovidDeaths$
order by 1,2 

-- Looking at Total Cases vs Total Deaths 
-- shows the likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)
From ProjectP..CovidDeaths$
order by 1,2
--(this didn't work beause I needed to convert into function that allows division)


--Had to convert from nvarchar to a decimal to be able to use the divide operator

Select 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    (CONVERT(DECIMAL(18, 2), (CONVERT(DECIMAL(18, 2), total_deaths)) / CONVERT(DECIMAL(18, 2), total_cases))) *100 as DeathPercentage
from ProjectP..CovidDeaths$
where location like '%states%'
order by 1,2

-- OR
Select location,date, total_cases,total_deaths, 
(cast(total_deaths as int))/(cast(total_deaths as int)) *100 as DeathPercentage
from ProjectP..CovidDeaths$
where location like '%states%'
order by 1,2


-- Looking at Total Cases vs Population (what percentage of population has gotten covid)
-- Shows what percentage of population got Covid
Select 
    location, 
    date,  
    population, 
	total_cases,
    (total_cases/population)*100 as PercentPopulationInfected
from ProjectP..CovidDeaths$
where location like '%states%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population

Select location,population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from ProjectP..CovidDeaths$
GROUP by location, population
order by  PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population
-- LET'S BREAK THINGS DOWN BY CONTINENT

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from ProjectP..CovidDeaths$
where location is not null
GROUP by continent
order by TotalDeathCount desc

-- Showing continents with the highest death country per population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from ProjectP..CovidDeaths$
where continent is not null
GROUP by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS
-- How to avoid the "divide by zero" error in SQL? : SET ARITHABORT OFF SET ANSI_WARNINGS OFF

SET ARITHABORT OFF 
SET ANSI_WARNINGS OFF
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/ SUM(New_cases)*100 as DeathPercentage
from ProjectP..CovidDeaths$
--where location like '%states%'
where continent is not null
--Group by date
order by 1,2

--Looking at Total Population vs Vaccinations
--USE CTE

With PopvsVac (Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_Vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From ProjectP..CovidDeaths$ dea
Join ProjectP..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac 





-- TEMP Table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_Vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From ProjectP..CovidDeaths$ dea
Join ProjectP..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_Vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From ProjectP..CovidDeaths$ dea
Join ProjectP..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated 
