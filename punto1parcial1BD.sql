------FUNCION PRINCIPAL-----------------------------------
CREATE OR REPLACE FUNCTION persist_audit()
  RETURNS TRIGGER 
  AS $$
  
DECLARE
boffname character varying;
deptname character varying;
posname character varying;
addname character varying;
citiname character varying;
countriname character varying;
supername character varying;


BEGIN

	
	if (TG_OP = 'UPDATE') THEN
	boffname= get_boff_name(old.branchid); 
	deptname= get_dept_name(old.departmentid); 
	posname= get_pos_name(old.positionid); 
	addname= get_add_name(old.addressid); 
	citiname= get_cityp_name(old.addressid);  
	countriname= get_country2_name(old.addressid); 
	supername=get_super_name(old.supervisorid);
	insert into "employeeaudit" 
	values(old.employeeid, old.fullname, boffname, deptname, posname, addname,citiname,countriname, supername,TG_OP, current_timestamp );
	return new;
	
	elsif (TG_OP = 'DELETE') then
	boffname= get_boff_name(old.branchid); 
	deptname= get_dept_name(old.departmentid); 
	posname= get_pos_name(old.positionid); 
	addname= get_add_name(old.addressid); 
	citiname= get_cityp_name(old.addressid);  
	countriname= get_country2_name(old.addressid); 
	supername=get_super_name(old.supervisorid);
	insert into "employeeaudit" 
	values(old.employeeid, old.fullname, boffname, deptname, posname, addname,citiname,countriname, supername,TG_OP, current_timestamp );
	return new; 
	
	elsif (TG_OP = 'INSERT') then
	boffname= get_boff_name(new.branchid); 
	deptname= get_dept_name(new.departmentid); 
	posname= get_pos_name(new.positionid); 
	addname= get_add_name(new.addressid); 
	citiname= get_cityp_name(new.addressid);  
	countriname= get_country2_name(new.addressid); 
	supername=get_super_name(new.supervisorid);
	insert into "employeeaudit" 
	values(new.employeeid, new.fullname, boffname, deptname,supername, posname, addname,citiname,countriname, TG_OP, current_timestamp );
	return new;
	END IF;
	
END
$$
LANGUAGE PLPGSQL;


-----------------------------------------------------------------------------
------------------FUNCIONES AUXILIARES---------------------------------------
------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_country2_name(add_id int)
  RETURNS character varying 
  LANGUAGE PLPGSQL
  AS $$
DECLARE 
	citi_id int;
BEGIN
	select cityid
	into citi_id
	from address
	where add_id = addressid;
		
	if not found then 
		raise 'address id % not found', add_id;
	end if;
	return get_country_name(get_countryp_name(citi_id));
END;$$

----------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_cityp_name(add_id int)
  RETURNS character varying 
  LANGUAGE PLPGSQL
  AS $$
DECLARE 
	citi_id int;
BEGIN
	select cityid
	into citi_id
	from address
	where add_id = addressid;
		
	if not found then 
		raise 'address id % not found', add_id;
	end if;
	return get_city_name(citi_id);
END;$$

select get_cityp_name(2);
---------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_city_name(citi_id int)
  RETURNS character varying 
  LANGUAGE PLPGSQL
  AS $$
DECLARE 
	citi_name character varying;
BEGIN
	select name
	into citi_name
	from city
	where citi_id = cityid;
		
	if not found then 
		raise 'city id % not found', citi_id;
	end if;
	return citi_name;
END;$$

select get_city_name(1);
------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_country_name(countri_id int)
  RETURNS character varying 
  LANGUAGE PLPGSQL
  AS $$
DECLARE 
	countri_name character varying;
BEGIN
	select name
	into countri_name
	from country
	where countri_id = countryid;
		
	if not found then 
		raise 'city id % not found', countri_id;
	end if;
	return countri_name;
END;$$
------------------------------------------------------
CREATE OR REPLACE FUNCTION get_countryp_name(cit_id int)
  RETURNS integer 
  LANGUAGE PLPGSQL
  AS $$
DECLARE 
	citi_id int;
BEGIN
	select countryid
	into citi_id
	from city
	where cit_id = cityid;
		
	if not found then 
		raise 'address id % not found', cit_id;
	end if;
	return citi_id;
END;$$
select get_country2_name(3);

drop function get_countryp_name(integer);
--------------------------------------------------------
CREATE OR REPLACE FUNCTION get_boff_name(bo_id int)
  RETURNS character varying 
  LANGUAGE PLPGSQL
  AS $$
DECLARE 
	boff_name character varying;
BEGIN
	select name
	into boff_name
	from branchoffice
	where bo_id = branchid;
		
	if not found then 
		raise 'Brach office id % not found', bo_id;
	end if;
	return boff_name;
END;$$

select get_country_name(3);

---------------------------------------------------

CREATE OR REPLACE FUNCTION get_dept_name(dept_id int)
  RETURNS character varying 
  LANGUAGE PLPGSQL
  AS $$
DECLARE 
	dept_name character varying;
BEGIN
	select name
	into dept_name
	from department
	where dept_id = departmentid;
		
	if not found then 
		raise 'Brach office id % not found', dept_id;
	end if;
	return dept_name;
END;$$

select get_dept_name(3);

------------------------------------------------------
CREATE OR REPLACE FUNCTION get_add_name(add_id int)
  RETURNS character varying 
  LANGUAGE PLPGSQL
  AS $$
DECLARE 
	add_name character varying;
BEGIN
	select line1
	into add_name
	from address
	where add_id = addressid;
		
	if not found then 
		raise 'Address id % not found', add_id;
	end if;
	return add_name;
END;$$

select get_add_name(3);
-----------------------------------------------------------
CREATE OR REPLACE FUNCTION get_pos_name(pos_id int)
  RETURNS character varying 
  LANGUAGE PLPGSQL
  AS $$
DECLARE 
	pos_name character varying;
BEGIN
	select name
	into pos_name
	from position
	where pos_id = positionid;
		
	if not found then 
		raise 'Position id % not found', pos_id;
	end if;
	return pos_name;
END;$$

select get_pos_name(1);
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_super_name(sup_id int)
  RETURNS character varying 
  LANGUAGE PLPGSQL
  AS $$
DECLARE 
	super_name character varying;
BEGIN
	select fullname
	into super_name
	from employee
	where sup_id = employeeid;
		
	if not found then 
		raise 'Supervisor id % not found', sup_id;
	end if;
	return super_name;
END;$$




------------------------Trigger-----------------------------------------
create trigger emp_update after insert or update or delete on employee
for each row 
execute procedure persist_audit();
----------------------------------------------------------------------



--------------------------ALGUNAS PRUEBAS--------------------------------
insert into employee values(102, 'karman punk',8, 7, 6, 15,80);
update employee set fullname='pajaro loco' where employeeid=100;
delete from employee where employeeid= 101;