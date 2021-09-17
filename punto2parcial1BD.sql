CREATE OR REPLACE VIEW public.past_jobs
 AS
select fullname, department 
from employeeaudit
inner join employee as e
on employee.employeeid=employeeaudit.employeeid
inner join branchoffice
on e.brachid= brachoffice.branchid
where branchoffice.branchid = 1;
ALTER TABLE public.past_jobs
    OWNER TO postgres;