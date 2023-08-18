-- Cleaning Data in SQL Queries
SELECT *
FROM [Portfolio Project-Data Cleaning].dbo.Nashville_Housing_Data


-- Standardize Date Format

SELECT SaleDateRevised
FROM [Portfolio Project-Data Cleaning].dbo.Nashville_Housing_Data


Alter table nashville_housing_data
add SaleDateRevised varchar(255);

update Nashville_Housing_Data
set SaleDateRevised=convert(date,SaleDate)

--Populate propertyAddress is null

select a.[UniqueID ],a.ParcelID,a.PropertyAddress,b.[UniqueID ],b.ParcelID,b.PropertyAddress,ISNULL(a.propertyaddress,b.PropertyAddress)
from Nashville_Housing_Data a
join Nashville_Housing_Data b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET a.propertyAddress=ISNULL(a.propertyaddress,b.PropertyAddress)
from Nashville_Housing_Data a
join Nashville_Housing_Data b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
/*(Here ParcelID is same where one of the property address of it is null, to identify it i have executed self join the table with
parcel id where unique id should not match. so we'll get null values wrt to same parcel id. here we use ISNULL command to transfer the 
data from one column to another column's null value.
verified if its right then updated the column)*/

--Breaking out Address column into adress and city

select PropertyAddress
from Nashville_Housing_Data

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(propertyaddress)) as CITY
from Nashville_Housing_Data

--Adding the new columns to the Table

Alter table nashville_housing_data
add PropertysplitAddress nvarchar(255)

update Nashville_Housing_Data
set PropertysplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table nashville_housing_data
add PropertySplitCity nvarchar(255)

update Nashville_Housing_Data
set propertysplitcity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(propertyaddress))

-- Altering owneraddress column same as property address
	select owneraddress
	from Nashville_Housing_Data
select
PARSENAME(Replace(owneraddress,',','.'),3) as OwnerSplitAddress,
PARSENAME(Replace(owneraddress,',','.'),2) as OwnerSplitCity,
PARSENAME(Replace(owneraddress,',','.'),1) as OwnerSplitState
from Nashville_Housing_Data
where OwnerAddress is not null

alter table nashville_Housing_Data
add OwnerSplitAddress NVARCHAR(255);

Update Nashville_Housing_Data
set Ownersplitaddress=PARSENAME(Replace(owneraddress,',','.'),3) 


alter table nashville_Housing_Data
add OwnerSplitCity NVARCHAR(255);

Update Nashville_Housing_Data
set Ownersplitcity=PARSENAME(Replace(owneraddress,',','.'),2)

alter table nashville_Housing_Data
add OwnerSplitState NVARCHAR(255);

Update Nashville_Housing_Data
set Ownersplitstate=PARSENAME(Replace(owneraddress,',','.'),1)

--Changing Y and n as Yes and No in Soldasvacant

select SoldAsVacant,count(soldasvacant)
from Nashville_Housing_Data
group by SoldAsVacant

select soldasvacant,
case
	when soldasvacant='y' then 'Yes'
	when soldasvacant='N' then 'No'
	else soldasvacant
	end
from Nashville_Housing_Data

update nashville_housing_data
set soldasvacant=case
	when soldasvacant='y' then 'Yes'
	when soldasvacant='N' then 'No'
	else soldasvacant
	end

--Deleting Duplicate values

with rownumCTE as(
Select *,
ROW_Number() over(partition by
				Parcelid,
				PropertyAddress,
				saleprice,
				Legalreference,
				saledate
				order by
				Uniqueid) row_num
from Nashville_Housing_Data
--order by ParcelID
)
delete
from rownumCTE
where row_num>1
--order by propertyaddress

with rownumCTE as(
Select *,
ROW_Number() over(partition by
				Parcelid,
				PropertyAddress,
				saleprice,
				Legalreference,
				saledate
				order by
				Uniqueid) row_num
from Nashville_Housing_Data
--order by ParcelID
)
select *
from rownumCTE
where row_num>1
order by propertyaddress

--Deleting unused column

alter table nashville_housing_data
drop column Propertyaddress,saledate,owneraddress,taxdistrict













