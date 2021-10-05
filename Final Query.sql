SELECT *
FROM CovidProject..CovidDeaths
ORDER BY 3,4


--SELECT *
--FROM CovidProject..CovidVaccinations
--ORDER BY 3,4

--Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidProject..CovidDeaths
ORDER BY 1,2
--location and date


--looking at total cases vs total deaths
--likelihood of dying if you contract COVID in United States
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidProject..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

--Looking at total cases vs population
--Percentage of population got COVID
SELECT location, date, population, total_cases, (total_cases/population)*100 as InfectionPercentage
FROM CovidProject..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to populations

SELECT location, population, MAX(total_cases) as HighestInfection, MAX((total_cases/population)*100) as PopulationInfectedPercentage
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY PopulationInfectedPercentage desc

--Countries with highest death count per population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeath
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is NOT null
GROUP BY location
ORDER BY TotalDeath desc

--Highest death count By Continent

SELECT location, MAX(cast(total_deaths as int)) as TotalDeath
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent IS null
GROUP BY location
ORDER BY TotalDeath desc


-- Global Numbers

SELECT SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases) *100 as DeathPercentage
FROM CovidProject..CovidDeaths
WHERE continent is NOT NULL
--Group By date
ORDER BY 1,2

--total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location)
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
FROM CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--USING CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location)
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--Temp Table

Drop Table if exists #PercentPopulationVaccinated
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
--SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location)
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




--Creating view to store data for visualization

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location)
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3



Select *
FROM PercentPopulationVaccinated





SELECT location, MAX(cast(total_deaths as int)) as TotalDeath
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is NOT null
GROUP BY location
ORDER BY TotalDeath desc


