-- Run in Supabase: SQL Editor > New query (run this file once)

-- 1) Questions
create table if not exists public.questions (
  id bigint generated always as identity primary key,
  company text not null,
  type text not null check (type in ('MCQ','Coding','Debugging')),
  question text not null,
  code text,
  options jsonb not null,
  answer int not null,
  explanation text,
  is_premium boolean not null default false,
  created_at timestamptz default now()
);
create index if not exists questions_company_idx on public.questions(company);
alter table public.questions enable row level security;

-- 2) Premium access (written only by the payment webhook, never by the browser)
create table if not exists public.entitlements (
  user_id uuid primary key references auth.users(id) on delete cascade,
  expires_at timestamptz not null,
  updated_at timestamptz default now()
);
alter table public.entitlements enable row level security;
drop policy if exists "Read own entitlement" on public.entitlements;
create policy "Read own entitlement" on public.entitlements for select using (auth.uid() = user_id);

create table if not exists public.payments (
  payment_id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  order_id text,
  amount int,
  created_at timestamptz default now()
);
alter table public.payments enable row level security;

create or replace function public.has_premium() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.entitlements e where e.user_id = auth.uid() and e.expires_at > now());
$$;

-- Free questions are public. Premium questions are readable only with an active plan.
drop policy if exists "Read questions" on public.questions;
create policy "Read questions" on public.questions for select to anon, authenticated
  using (not is_premium or public.has_premium());

-- Lets the site show "N premium questions" without exposing them.
create or replace function public.premium_counts() returns table(company text, n bigint)
language sql stable security definer set search_path = public as $$
  select company, count(*) from public.questions where is_premium group by company;
$$;
grant execute on function public.premium_counts() to anon, authenticated;

-- 3) Starter questions (replace with your own content over time)
insert into public.questions (company,type,question,code,options,answer,explanation,is_premium) values
($q$TCS$q$,$q$MCQ$q$,$q$Which of these is NOT a primitive data type in Java?$q$,null,$q$["int", "boolean", "String", "char"]$q$::jsonb,2,$q$String is a class, not a primitive type.$q$,false),
($q$TCS$q$,$q$Coding$q$,$q$What is the output?$q$,$q$int a = 10, b = 3;
printf("%d %d", a / b, a % b);$q$,$q$["3 1", "3.33 1", "3 0", "4 1"]$q$::jsonb,0,$q$Integer division gives 3 and the remainder is 1.$q$,false),
($q$TCS$q$,$q$Coding$q$,$q$What is the output?$q$,$q$int i = 0;
while (i++ < 3)
    printf("%d ", i);$q$,$q$["0 1 2", "1 2 3", "1 2 3 4", "0 1 2 3"]$q$::jsonb,1,$q$i++ < 3 compares the old value, then increments, so the body prints 1, 2, 3.$q$,true),
($q$TCS$q$,$q$MCQ$q$,$q$Which sorting algorithm has the best worst-case time complexity?$q$,null,$q$["Quick sort", "Merge sort", "Bubble sort", "Insertion sort"]$q$::jsonb,1,$q$Merge sort is O(n log n) in every case. Quick sort degrades to O(n²).$q$,true),
($q$Infosys$q$,$q$Debugging$q$,$q$Why does this code fail?$q$,$q$def add(x, y):
    return x + y
print(add(2))$q$,$q$["Missing return", "Missing argument y, so TypeError", "Wrong indentation", "print is not allowed"]$q$::jsonb,1,$q$add needs two arguments, but only one is passed.$q$,false),
($q$Infosys$q$,$q$MCQ$q$,$q$Which normal form removes partial dependency?$q$,null,$q$["1NF", "2NF", "3NF", "BCNF"]$q$::jsonb,1,$q$2NF removes partial dependencies on a composite key.$q$,false),
($q$Infosys$q$,$q$Coding$q$,$q$What is the output?$q$,$q$x = [1, 2, 3]
y = x[:]
y.append(4)
print(x, y)$q$,$q$["[1, 2, 3, 4] [1, 2, 3, 4]", "[1, 2, 3] [1, 2, 3, 4]", "[1, 2, 3] [1, 2, 3]", "Error"]$q$::jsonb,1,$q$x[:] makes a copy, so changing y does not change x.$q$,true),
($q$Infosys$q$,$q$MCQ$q$,$q$A process moves from the ready state to running when:$q$,null,$q$["It requests I/O", "The scheduler dispatches it", "It terminates", "It is swapped out"]$q$::jsonb,1,$q$The scheduler picks a ready process and dispatches it to the CPU.$q$,true),
($q$Wipro$q$,$q$MCQ$q$,$q$Which data structure is used for BFS traversal of a graph?$q$,null,$q$["Stack", "Queue", "Heap", "Tree"]$q$::jsonb,1,$q$BFS visits nodes level by level, which a queue supports.$q$,false),
($q$Wipro$q$,$q$Coding$q$,$q$What is the output?$q$,$q$int x = 7;
x = x << 1;
printf("%d", x);$q$,$q$["7", "14", "3", "21"]$q$::jsonb,1,$q$Left shift by 1 doubles the value.$q$,false),
($q$Wipro$q$,$q$MCQ$q$,$q$A train 120 m long passes a pole in 6 seconds. Its speed in km/h is:$q$,null,$q$["60", "72", "80", "54"]$q$::jsonb,1,$q$120/6 = 20 m/s, and 20 × 18/5 = 72 km/h.$q$,true),
($q$Wipro$q$,$q$Debugging$q$,$q$What is the bug?$q$,$q$int arr[5];
for (int i = 0; i <= 5; i++)
    arr[i] = i;$q$,$q$["Array too small to declare", "The loop writes arr[5], outside the array", "i must be a float", "Missing return"]$q$::jsonb,1,$q$A size-5 array has indexes 0 to 4. The condition i <= 5 goes one too far.$q$,true),
($q$Accenture$q$,$q$MCQ$q$,$q$Which is an example of Infrastructure as a Service (IaaS)?$q$,null,$q$["Gmail", "Amazon EC2", "Salesforce", "Google Docs"]$q$::jsonb,1,$q$EC2 rents virtual machines, which is IaaS.$q$,false),
($q$Accenture$q$,$q$MCQ$q$,$q$Which HTTP method is idempotent and used to replace a resource?$q$,null,$q$["POST", "PUT", "PATCH", "CONNECT"]$q$::jsonb,1,$q$PUT replaces a resource and repeating it gives the same result.$q$,false),
($q$Accenture$q$,$q$Coding$q$,$q$What is the output?$q$,$q$String a = "hi";
String b = new String("hi");
System.out.println(a == b);$q$,$q$["true", "false", "Compile error", "Runtime error"]$q$::jsonb,1,$q$== compares references. new String creates a separate object.$q$,true),
($q$Accenture$q$,$q$MCQ$q$,$q$Which problem occurs when a transaction reads another transaction's uncommitted data?$q$,null,$q$["Dirty read", "Phantom read", "Lost update", "Deadlock"]$q$::jsonb,0,$q$Reading uncommitted data is called a dirty read.$q$,true),
($q$Cognizant$q$,$q$Coding$q$,$q$What is the output?$q$,$q$print(10 // 3, 10 % 3, 2 ** 3)$q$,$q$["3 1 8", "3.33 1 6", "3 1 6", "3 3 8"]$q$::jsonb,0,$q$// is floor division, % is remainder and ** is power.$q$,false),
($q$Cognizant$q$,$q$MCQ$q$,$q$Which of these is a stable sorting algorithm?$q$,null,$q$["Quick sort", "Heap sort", "Merge sort", "Selection sort"]$q$::jsonb,2,$q$Merge sort keeps equal elements in their original order.$q$,false),
($q$Cognizant$q$,$q$Debugging$q$,$q$What happens when this runs?$q$,$q$int[] a = new int[3];
System.out.println(a[3]);$q$,$q$["Prints 0", "ArrayIndexOutOfBoundsException", "Compile error", "Prints null"]$q$::jsonb,1,$q$The array has indexes 0 to 2, so a[3] is out of range.$q$,true),
($q$Cognizant$q$,$q$Coding$q$,$q$What is the output?$q$,$q$def f(n, acc=[]):
    acc.append(n)
    return acc
f(1)
print(f(2))$q$,$q$["[2]", "[1, 2]", "[1]", "Error"]$q$::jsonb,1,$q$The default list is created once and shared between calls.$q$,true),
($q$Capgemini$q$,$q$MCQ$q$,$q$What is the value of 5 + 3 * 2?$q$,null,$q$["16", "11", "10", "13"]$q$::jsonb,1,$q$Multiplication comes first: 3 × 2 = 6, then 5 + 6 = 11.$q$,false),
($q$Capgemini$q$,$q$MCQ$q$,$q$Which OOP concept lets one interface have many implementations?$q$,null,$q$["Encapsulation", "Polymorphism", "Abstraction", "Inheritance"]$q$::jsonb,1,$q$Polymorphism means many forms behind one interface.$q$,false),
($q$Capgemini$q$,$q$MCQ$q$,$q$The ratio of A to B is 3:5 and A is 21. What is B?$q$,null,$q$["30", "35", "40", "45"]$q$::jsonb,1,$q$One part is 21/3 = 7, so B = 5 × 7 = 35.$q$,true),
($q$Capgemini$q$,$q$Coding$q$,$q$What is the output?$q$,$q$char s[] = "abc";
printf("%d", sizeof(s));$q$,$q$["3", "4", "5", "8"]$q$::jsonb,1,$q$sizeof counts the 3 letters plus the null terminator.$q$,true),
($q$HCLTech$q$,$q$MCQ$q$,$q$Which OSI layer handles routing?$q$,null,$q$["Data link", "Network", "Transport", "Session"]$q$::jsonb,1,$q$The network layer routes packets using IP addresses.$q$,false),
($q$HCLTech$q$,$q$MCQ$q$,$q$Which protocol is connection-oriented?$q$,null,$q$["UDP", "TCP", "IP", "ICMP"]$q$::jsonb,1,$q$TCP sets up a connection with a handshake before sending data.$q$,false),
($q$HCLTech$q$,$q$Coding$q$,$q$What is the output?$q$,$q$int a = 5;
int *p = &a;
*p = *p + 2;
printf("%d", a);$q$,$q$["5", "7", "2", "An address"]$q$::jsonb,1,$q$*p changes a through the pointer: 5 + 2 = 7.$q$,true),
($q$HCLTech$q$,$q$MCQ$q$,$q$Which is NOT one of the four necessary conditions for deadlock?$q$,null,$q$["Mutual exclusion", "Hold and wait", "Circular wait", "Preemption"]$q$::jsonb,3,$q$No preemption is required for deadlock. Allowing preemption would prevent it.$q$,true),
($q$Amazon$q$,$q$MCQ$q$,$q$What is the average lookup time in a hash table with good hashing?$q$,null,$q$["O(1)", "O(log n)", "O(n)", "O(n log n)"]$q$::jsonb,0,$q$A good hash spreads keys, so lookups take constant time on average.$q$,false),
($q$Amazon$q$,$q$MCQ$q$,$q$Which structure gives the smallest element repeatedly and efficiently?$q$,null,$q$["Stack", "Queue", "Min-heap", "Array"]$q$::jsonb,2,$q$A min-heap returns the minimum in O(1) and removes it in O(log n).$q$,false),
($q$Amazon$q$,$q$Coding$q$,$q$What is the output?$q$,$q$from collections import deque
d = deque([1, 2, 3])
d.rotate(1)
print(list(d))$q$,$q$["[2, 3, 1]", "[3, 1, 2]", "[1, 2, 3]", "[3, 2, 1]"]$q$::jsonb,1,$q$rotate(1) moves the last element to the front.$q$,true),
($q$Amazon$q$,$q$MCQ$q$,$q$Best time complexity for Two Sum on an unsorted array, using extra space?$q$,null,$q$["O(n\u00b2)", "O(n log n)", "O(n)", "O(1)"]$q$::jsonb,2,$q$Store seen values in a hash map and check the complement in one pass.$q$,true),
($q$Zoho$q$,$q$Coding$q$,$q$What is the output?$q$,$q$int i;
for (i = 0; i < 3; i++);
printf("%d", i);$q$,$q$["0", "2", "3", "Error"]$q$::jsonb,2,$q$The semicolon ends the loop, which runs until i becomes 3.$q$,false),
($q$Zoho$q$,$q$MCQ$q$,$q$How many nodes are in a full binary tree of height 3 (root at height 0)?$q$,null,$q$["7", "8", "15", "16"]$q$::jsonb,2,$q$2^(h+1) − 1 = 2⁴ − 1 = 15.$q$,false),
($q$Zoho$q$,$q$Debugging$q$,$q$What is wrong here?$q$,$q$char *s = "hello";
s[0] = 'H';$q$,$q$["Works and prints Hello", "Undefined behaviour: string literals are read-only", "Needs strcpy", "It is always a compile error"]$q$::jsonb,1,$q$Modifying a string literal is undefined behaviour. Use char s[] = "hello";.$q$,true),
($q$Zoho$q$,$q$Coding$q$,$q$What is the output?$q$,$q$int a[] = {1, 2, 3, 4};
printf("%d", sizeof(a) / sizeof(a[0]));$q$,$q$["4", "16", "8", "1"]$q$::jsonb,0,$q$Total bytes divided by bytes per element gives the element count: 4.$q$,true),
($q$Tech Mahindra$q$,$q$MCQ$q$,$q$Which of these is a NoSQL database?$q$,null,$q$["MySQL", "PostgreSQL", "MongoDB", "Oracle"]$q$::jsonb,2,$q$MongoDB is a document-oriented NoSQL database.$q$,false),
($q$Tech Mahindra$q$,$q$MCQ$q$,$q$Which keyword declares a constant binding in JavaScript?$q$,null,$q$["var", "let", "const", "static"]$q$::jsonb,2,$q$const prevents reassignment of the variable.$q$,false),
($q$Tech Mahindra$q$,$q$Coding$q$,$q$What is the output?$q$,$q$console.log(typeof null);$q$,$q$["null", "undefined", "object", "string"]$q$::jsonb,2,$q$typeof null is "object", a long-standing JavaScript quirk.$q$,true),
($q$Tech Mahindra$q$,$q$Coding$q$,$q$What is the output?$q$,$q$console.log([1, 2, 3]
  .map(x => x * 2)
  .filter(x => x > 2).length);$q$,$q$["1", "2", "3", "0"]$q$::jsonb,1,$q$map gives [2, 4, 6], filter keeps [4, 6], so the length is 2.$q$,true),
($q$Deloitte$q$,$q$MCQ$q$,$q$Which counts only non-NULL values?$q$,null,$q$["COUNT(*)", "COUNT(column)", "Both", "Neither"]$q$::jsonb,1,$q$COUNT(column) skips NULLs. COUNT(*) counts every row.$q$,false),
($q$Deloitte$q$,$q$MCQ$q$,$q$A sum doubles in 5 years at simple interest. In how many years will it become 4 times?$q$,null,$q$["10", "15", "20", "25"]$q$::jsonb,1,$q$Interest is P per 5 years. To reach 4P you need 3P of interest: 15 years.$q$,false),
($q$Deloitte$q$,$q$Coding$q$,$q$Salaries in emp are 100, 200, 200, 300. What does this return?$q$,$q$SELECT DISTINCT salary FROM emp
ORDER BY salary DESC
LIMIT 1 OFFSET 1;$q$,$q$["100", "200", "300", "NULL"]$q$::jsonb,1,$q$Distinct salaries in descending order are 300, 200, 100. Skipping one gives 200.$q$,true),
($q$Deloitte$q$,$q$MCQ$q$,$q$Which Git command moves a branch's commits onto a new base?$q$,null,$q$["git stash", "git rebase", "git fetch", "git blame"]$q$::jsonb,1,$q$git rebase replays your commits on top of another base commit.$q$,true),
($q$LTIMindtree$q$,$q$MCQ$q$,$q$Which block always runs after try and catch in Java?$q$,null,$q$["catch", "finally", "throw", "throws"]$q$::jsonb,1,$q$finally runs whether or not an exception happened.$q$,false),
($q$LTIMindtree$q$,$q$MCQ$q$,$q$Which data structure does recursion use internally?$q$,null,$q$["Queue", "Stack", "Heap", "Graph"]$q$::jsonb,1,$q$Each call is pushed onto the call stack.$q$,false),
($q$LTIMindtree$q$,$q$Coding$q$,$q$What is the output?$q$,$q$int x = 5;
System.out.println(x++ * 2);$q$,$q$["10", "12", "11", "Error"]$q$::jsonb,0,$q$x++ uses 5 first and increments afterwards, so 5 × 2 = 10.$q$,true),
($q$LTIMindtree$q$,$q$Coding$q$,$q$What is the output?$q$,$q$s = "placement"
print(s[::-1][:3])$q$,$q$["pla", "tne", "ent", "ten"]$q$::jsonb,1,$q$Reversed it is "tnemecalp", and the first three characters are "tne".$q$,true);
