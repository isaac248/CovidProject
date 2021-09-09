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

--



