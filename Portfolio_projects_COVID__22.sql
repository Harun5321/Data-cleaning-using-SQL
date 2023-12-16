--COVID 19 Exploration

select *
from Portfolio_projects..CovidDeaths
where continent is not null
order by 3,4

--SELECT the data that we are going start with
select location, date,total_cases,total_deaths , population 
from Portfolio_projects..CovidDeaths
where continent is not null
order by 1,2

--Total Cases VS Total Deaths
-- Shows likelihood of dying if you contract Covid 19

select location, date,total_cases,total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
from Portfolio_projects..CovidDeaths
where location like '%Nigeria%'
and continent is not null
order by 1,2

--Total Cases VS Population
--Shows THE % infected with Covid

select location, date,total_cases,total_deaths , (total_cases/population)*100 as PercentageInfected
from Portfolio_projects..CovidDeaths
--where location like '%Nigeria%'
order by 1,2

--Countries with Highest Infection Rate compared Population

select location, population, MAX(total_cases) as HighestInfectionCount,MAX(total_cases/population)*100 as PercentagePopulationInfected
from Portfolio_projects..CovidDeaths
GROUP BY  location, population
order by PercentagePopulationInfected desc

--Countries With Highest Death Count Per Population
select location, MAX(convert(int,Total_deaths)) as TotalDeathCount
from Portfolio_projects..CovidDeaths
where continent is not null
GROUP BY  location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

select continent, MAX(convert(int,Total_deaths)) as TotalDeathCount
from Portfolio_projects..CovidDeaths
where continent is not null
GROUP BY  continent
order by TotalDeathCount desc -- GLOBAL NUMBERS

--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Portfolio_projects..CovidDeaths
where continent is not null 
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select Death.continent, Death.location, Death.date, Death.population, Vaccine.new_vaccinations
, SUM(CONVERT(int,Vaccine.new_vaccinations)) OVER (Partition by Death.Location Order by Death.location, Death.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Portfolio_projects..CovidDeaths Death
Join Portfolio_projects..CovidVaccinations Vaccine
	On Death.location = Vaccine.location
	and Death.date = Vaccine.date
where Death.continent is not null 
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select Death.continent, Death.location, Death.date, Death.population, Vaccine.new_vaccinations
, SUM(CONVERT(int,Vaccine.new_vaccinations)) OVER (Partition by Deaths.Location Order by Deaths.location, Deaths.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Portfolio_projects..CovidDeaths Death
Join Portfolio_projects..CovidVaccinations Vaccine
	On Death.location = Vaccine.location
	and Death.date = Vaccine.date
where Death.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

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
Select Death.continent, Death.location, Death.date, Death.population, Vaccine.new_vaccinations
, SUM(CONVERT(int,Vaccine.new_vaccinations)) OVER (Partition by Death.Location Order by Death.location, Death.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Portfolio_projects..CovidDeaths Death
Join Portfolio_projects..CovidVaccinations Vaccine
	On Death.location = Vaccine.location
	and Death.date = Vaccine.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select Death.continent, Death.location, Death.date, Death.population, Vaccine.new_vaccinations
, SUM(CONVERT(int,Vaccine.new_vaccinations)) OVER (Partition by Death.Location Order by Death.location, Death.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Portfolio_projects..CovidDeaths Death
Join Portfolio_projects..CovidVaccinations Vaccine
	On Death.location = Vaccine.location
	and Death.date = Vaccine.date
where Death.continent is not null 

--MINE

--Total Number Of Cases, Vaccinations & Deaths For Each Country
select cd.location, SUM(CONVERT(bigint,cd.total_cases))AS TotalCases,
				    SUM(CONVERT(bigint,cv.total_vaccinations)) AS TotalVaccinations,
					SUM(CONVERT(bigint,cd.total_deaths)) AS TotalDeaths
from Portfolio_projects..CovidDeaths cd
JOIN Portfolio_projects..[CovidVaccinations] cv ON cd.location = cv.location
Group by cd.location
order by cd.location



	--delete from  Portfolio_projects..CovidDeaths
	--where location = 'Antactica'


--Total cases and deaths globally:
select SUM(total_cases) AS TotalCases, SUM(convert(int, total_deaths)) AS TotalDeaths
from [Portfolio_projects]..CovidDeaths

--Total cases and deaths in Ngeria:
select SUM(total_cases) AS TotalCases, SUM(convert(int, total_deaths)) AS TotalDeaths
from [Portfolio_projects]..CovidDeaths
where location like '%Nigeria%'


--MAX New cases and New deaths in Ngeria:
select MAX(new_cases) AS MaxCase, MAX(convert(int, new_deaths)) AS MaxDeath
from [Portfolio_projects]..CovidDeaths
where location like '%Nigeria%'


--Evolution of cases and deaths over time:
select date,  SUM(new_cases) AS DailyCases, SUM(convert(int, new_deaths)) AS DailyDeaths
from [Portfolio_projects]..CovidDeaths
GROUP BY date
order by 1


--Vaccination progress over time:
select date,  SUM(cast(new_vaccinations as int )) AS DailyVaccinations
from [Portfolio_projects]..CovidDeaths
GROUP BY date
order by 1
