select * from PortifolioProject..CovidDeaths
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population 
from PortifolioProject..CovidDeaths
order by 1,2

--total cases vs total deaths
select location,date,total_cases,total_deaths, 
round(100*(total_deaths/total_cases),2) mortality_rate
from PortifolioProject..CovidDeaths
where location like 'Bra%'
order by 1,2

--total cases vs population
select location,date,total_cases,population, 
round(100*(total_cases/population),2) percent_infected
from PortifolioProject..CovidDeaths
where location like 'Bra%'
order by 1,2

-- order countries by highest infection rate
select location,population, max(total_cases) highest_infection_count,
max(round(100*(total_cases/population),2)) percent_infected
from PortifolioProject..CovidDeaths
group by location,population
order by percent_infected desc

-- order countries by highest death rate
select location, max(cast(total_deaths as int)) death_count
from PortifolioProject..CovidDeaths
where continent is not null
group by location
order by death_count desc

-- continents
select location, max(cast(total_deaths as int)) death_count
from PortifolioProject..CovidDeaths
where continent is null
group by location
order by death_count desc

--global numbers
select date, sum(new_cases) total_cases,
sum(cast(new_deaths as int)) total_deaths,
(sum(cast(new_deaths as int))/sum(new_cases))*100 death_percentage
from PortifolioProject..CovidDeaths
where continent is not null
group by date
order by 1, 2

--total population vs vaccinations
create view pop_vac as (select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as people_vaccinated
from PortifolioProject..CovidDeaths dea
join PortifolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
select *, 100*(people_vaccinated/population)
from pop_vac
