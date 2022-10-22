SELECT * 
FROM PortfolioProject..covidDeaths
ORDER BY 3,4


--SELECT * 
--FROM PortfolioProject..covidVaccinations
--ORDER BY 3,4
--SELECTING DATA TO WORK ON 

SELECT DATE, NEW_CASES, TOTAL_CASES, TOTAL_DEATHS, population
FROM PortfolioProject..covidDeaths
ORDER BY 1,2

--SELECTING TOTAL CASES VS TOTAL DEATHS

SELECT DATE, POPULATION, TOTAL_CASES, TOTAL_DEATHS
FROM PortfolioProject..covidDeaths
ORDER BY DATE

--At my place cased and deaths reported
SELECT Location, DATE, TOTAL_CASES, TOTAL_DEATHS, (TOTAL_DEATHS/TOTAL_CASES)*100 AS DeathPercentage
From PortfolioProject..covidDeaths
Where location like'%Pakistan%'
order by 1,2

--Looking total cases vs population
--Shows what population percentage got covid

SELECT Location, DATE, population TOTAL_CASES, (TOTAL_cases/population)*100 AS DeathPercentage
From PortfolioProject..covidDeaths
Where location like'%Pakistan%'
order by 1,2
--All over the world population vs total cases

SELECT Location, DATE, population TOTAL_CASES, (TOTAL_cases/population)*100 AS DeathPercentage
From PortfolioProject..covidDeaths
order by 1,2

--Which country has highest infection rate

SELECT Location, population, Max(total_cases) as HighestInfectCount, Max((total_cases/population))*100 as PerentageOfPopulationInfected
From PortfolioProject..covidDeaths
Group by Location, Population
order by PerentageOfPopulationInfected

--Showing Countries with highest death count per population

SELECT Location,  Max(cast(total_cases as int)) as TotalDeathCount
From PortfolioProject..covidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT

SELECT LOCATION,  Max(cast(total_cases as int)) as TotalDeathCount
From PortfolioProject..covidDeaths
Where continent is  null
Group by LOCATION
order by TotalDeathCount desc

--by continent
SELECT continent,  Max(cast(total_cases as int)) as TotalDeathCount
From PortfolioProject..covidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


--Showing the continent with highest death rate.

SELECT continent,  Max(cast(total_cases as int)) as TotalDeathCount
From PortfolioProject..covidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


--Global Numbers

Select SUM(total_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
From PortfolioProject..covidDeaths
where continent is not null
order by 1, 2

--Looking at total population vs vaccination 

Select * 
From PortfolioProject..covidDeaths dea
Join PortfolioProject..covidVaccinations vac
 on dea.location =vac.location and dea.date= vac.date

 --Looking at total population vs vaccination 


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(CONVERT(int,  vac.new_vaccinations)) 
 OVER (Partition by dea.location Order by 
 dea.location, dea.date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
From PortfolioProject..covidDeaths dea
Join PortfolioProject..covidVaccinations vac
    on dea.location =vac.location 
	and dea.date= vac.date
where dea.continent is not null
 order by 2,3 

 --Use CTE

-- With PopvsVac(Continent, Location, Date, Population,New_Vaccination, RollingPeopleVaccinated)
-- as
--(
-- Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
-- SUM(CONVERT(int,  vac.new_vaccinations)) 
-- OVER (Partition by dea.location Order by 
-- dea.location, dea.date) as RollingPeopleVaccinated
-- --,(RollingPeopleVaccinated/population)*100
--From PortfolioProject..covidDeaths dea
--Join PortfolioProject..covidVaccinations vac
--    on dea.location =vac.location 
--	and dea.date= vac.date
--where dea.continent is not null
-- --order by 2,3 
-- )
-- Select * From PopvsVac


 --Another query

With PopvsVac(Continent, Location, Date, Population,New_Vaccination, RollingPeopleVaccinated)as
(
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(CONVERT(int,  vac.new_vaccinations)) 
 OVER (Partition by dea.location Order by 
 dea.location, dea.date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
From PortfolioProject..covidDeaths dea
Join PortfolioProject..covidVaccinations vac
    on dea.location =vac.location 
	and dea.date= vac.date
where dea.continent is not null
 --order by 2,3 
 )
 Select *, (RollingPeopleVaccinated/Population)*100
 From PopvsVac


 --Temp table
 DROp table if exists PercentPopulationVaccinated
 Create table PersentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_Vaccination numeric,
 RollingPeopleVaccinated numeric
 )

 Insert into PersentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(Cast(vac.new_vaccinations as int))  OVER (Partition by dea.location Order by 
 dea.location, dea.date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
From PortfolioProject..covidDeaths dea
Join PortfolioProject..covidVaccinations vac
    on dea.location =vac.location 
	and dea.date= vac.date
where dea.continent is not null
 --order by 2,3 

 Select *, (RollingPeopleVaccinated/Population) *100
 From PersentPopulationVaccinated

 --Creating View to store data for later visualizations
  Create View PercentPopulationVaccinated as 
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(Cast(vac.new_vaccinations as int))  OVER (Partition by dea.location Order by 
 dea.location, dea.date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
From PortfolioProject..covidDeaths dea
Join PortfolioProject..covidVaccinations vac
    on dea.location =vac.location 
	and dea.date= vac.date
where dea.continent is not null
--order by 2,3


--to get view data
Select * 
From PercentPopulationVaccinated

SELECT TOP (1000) [continent]
      ,[location]
      ,[date]
      ,[population]
      ,[new_vaccinations]
      ,[RollingPeopleVaccinated]
  FROM [PortfolioProject].[dbo].[PercentPopulationVaccinated]