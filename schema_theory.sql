-- Run once in Supabase: SQL Editor > New query
-- Adds Theory and Behavioral questions (question + written answer, no options).

alter table public.questions add column if not exists answer_text text;
alter table public.questions alter column options drop not null;
alter table public.questions alter column answer drop not null;
alter table public.questions drop constraint if exists questions_type_check;
alter table public.questions add constraint questions_type_check
  check (type in ('MCQ','Coding','Debugging','Theory','Behavioral'));

insert into public.questions (company,type,question,code,options,answer,explanation,is_premium,answer_text) values
($q$TCS$q$,$q$Theory$q$,$q$What is the difference between a process and a thread?$q$,null,null,null,null,false,$q$A process is an independent program in execution with its own memory space. A thread is a lightweight unit of execution inside a process.
Threads of one process share memory (code, heap, open files) but each has its own stack and registers.
Creating and switching threads is cheaper than processes. Processes are isolated, so one crash does not affect another, while a thread crash can bring down the whole process. Sharing data between threads is easy but needs synchronisation (locks) to avoid race conditions.$q$),
($q$TCS$q$,$q$Theory$q$,$q$What is normalization? Explain 1NF, 2NF and 3NF.$q$,null,null,null,null,true,$q$Normalization organises tables to reduce redundancy and update anomalies.
1NF: every column holds atomic (single) values and there are no repeating groups.
2NF: 1NF plus no partial dependency, meaning no non-key column depends on only part of a composite key.
3NF: 2NF plus no transitive dependency, meaning non-key columns depend only on the key, not on other non-key columns.
Example: a table (OrderID, ProductID, ProductName) breaks 2NF because ProductName depends only on ProductID. Move product details to a separate Product table.$q$),
($q$TCS$q$,$q$Behavioral$q$,$q$Tell me about yourself.$q$,null,null,null,null,false,$q$Keep it to about 60 to 90 seconds: present, past, future.
Sample: "I am [name], a final-year [branch] student at [college]. I enjoy problem solving and have built [project] using [skills], where I [result]. I also practise DSA regularly and completed [certification or internship]. I am looking for an opportunity to apply these skills in a real team and keep learning."
Tips: use real details, do not read your resume aloud, and end by linking to the role.$q$),
($q$TCS$q$,$q$Behavioral$q$,$q$Why do you want to join TCS?$q$,null,null,null,null,true,$q$Show you researched the company and connect it to your goals.
Sample: "TCS works with clients across many industries, so I would get exposure to different technologies and domains early in my career. The training and the chance to work on large projects match what I want right now: a strong foundation before specialising."
Avoid mentioning only salary or brand name. Add one specific thing you learned about the company, such as a recent project or news item.$q$),
($q$Infosys$q$,$q$Theory$q$,$q$Explain the four pillars of OOP.$q$,null,null,null,null,false,$q$Encapsulation: bundling data and methods in a class and hiding internal details using access modifiers (for example private fields with getters).
Abstraction: exposing only what is necessary, using abstract classes and interfaces.
Inheritance: a child class reuses and extends a parent class (an is-a relationship).
Polymorphism: one interface, many forms. Compile-time through method overloading, run-time through method overriding.
Example: a Shape interface with area(); Circle and Rectangle each implement it differently.$q$),
($q$Infosys$q$,$q$Theory$q$,$q$What are the ACID properties of a transaction?$q$,null,null,null,null,true,$q$ACID describes the guarantees of a database transaction.
Atomicity: all operations succeed or none do (in a money transfer, the debit and credit both happen or neither).
Consistency: a transaction moves the database from one valid state to another and respects constraints.
Isolation: concurrent transactions do not interfere, and intermediate states are not visible to others.
Durability: once committed, data survives crashes because it is written to disk and logs.$q$),
($q$Infosys$q$,$q$Behavioral$q$,$q$Describe a time you had to learn something new quickly.$q$,null,null,null,null,false,$q$Use the STAR format: Situation, Task, Action, Result.
Sample: "In my final year, our project needed React and I had never used it. I had two weeks to build the front end. I followed the official docs, built a small practice app first, and asked a senior to review my code. We delivered on time and I later helped teammates with it."
Pick a real example and finish with what you learned.$q$),
($q$Infosys$q$,$q$Behavioral$q$,$q$Are you comfortable with relocation and working in shifts?$q$,null,null,null,null,true,$q$Be honest and positive. Do not promise what you cannot do.
Sample: "Yes, I am open to relocating. I see it as a chance to learn and grow, and I am prepared to adapt to a new city. I understand that project needs can involve different shifts, and I am willing to work with that."
If you have a genuine constraint, state it calmly and say what you can do, instead of giving a flat no.$q$),
($q$Wipro$q$,$q$Theory$q$,$q$What is the difference between a stack and a queue?$q$,null,null,null,null,false,$q$A stack is LIFO (last in, first out). A queue is FIFO (first in, first out).
Stack operations: push and pop at one end (the top). Uses: function calls, undo, expression evaluation, DFS.
Queue operations: enqueue at the rear and dequeue from the front. Uses: scheduling, buffering, BFS.
Both can be built with arrays or linked lists, and the basic operations take O(1).$q$),
($q$Wipro$q$,$q$Theory$q$,$q$What is a deadlock? How can it be prevented?$q$,null,null,null,null,true,$q$Deadlock is when a set of processes wait forever, each holding a resource another one needs.
Four necessary conditions: mutual exclusion, hold and wait, no preemption, circular wait.
Prevention: break at least one condition, for example request all resources at once, allow preemption, or impose an ordering on resource requests.
Avoidance: the Banker's algorithm grants a request only if the system stays in a safe state.
Detection and recovery: find cycles in the resource graph and terminate or roll back a process.$q$),
($q$Wipro$q$,$q$Behavioral$q$,$q$What are your strengths and weaknesses?$q$,null,null,null,null,false,$q$Pick strengths relevant to the role and prove them with a short example. For a weakness, choose a real, minor one and show you are improving it.
Sample: "My strength is consistent problem solving: I practise DSA regularly and used it in my project. A weakness is that I sometimes spend too long perfecting details, so I now set time limits for each task."
Avoid cliches like "I work too hard", and never say you have no weakness.$q$),
($q$Wipro$q$,$q$Behavioral$q$,$q$Describe a time you worked in a team and faced a conflict.$q$,null,null,null,null,true,$q$Use STAR and show that you listened and focused on the goal, not on blame.
Sample: "In a group project, two teammates disagreed on the database design. I needed the team to decide quickly. I asked each to explain the trade-offs, we listed pros and cons together, and tested both options on sample data. We chose the faster design and met our deadline, and the disagreement ended without bad feeling."$q$),
($q$Accenture$q$,$q$Theory$q$,$q$What is cloud computing? Explain IaaS, PaaS and SaaS.$q$,null,null,null,null,false,$q$Cloud computing delivers computing resources (servers, storage, databases, software) over the internet on a pay-as-you-go basis.
IaaS: rent virtual machines and storage (for example Amazon EC2).
PaaS: a platform to run your code without managing servers (for example Google App Engine).
SaaS: finished software used through a browser (for example Gmail).
Benefits: scalability, lower upfront cost and flexibility. Deployment types: public, private and hybrid.$q$),
($q$Accenture$q$,$q$Theory$q$,$q$Compare the Agile and Waterfall models.$q$,null,null,null,null,true,$q$Waterfall is a linear process: requirements, design, build, test, deploy, with each phase finishing before the next. It suits fixed, well-understood requirements but handles change poorly.
Agile works in short iterations (sprints, usually 1 to 4 weeks), delivering working software each time with regular customer feedback. It handles changing requirements well.
Scrum is a common Agile framework, with roles such as product owner and scrum master, and events like daily stand-ups and retrospectives.$q$),
($q$Accenture$q$,$q$Behavioral$q$,$q$Where do you see yourself in five years?$q$,null,null,null,null,false,$q$Show ambition that fits the company and the role, without sounding like you will leave quickly.
Sample: "In five years I want to be a skilled professional who has contributed to successful projects, learned from experienced colleagues, and taken on more responsibility, maybe leading a small team. For now my focus is building strong fundamentals."
Avoid naming a rival company or a role unrelated to the job.$q$),
($q$Accenture$q$,$q$Behavioral$q$,$q$Tell me about a time you worked under pressure or a tight deadline.$q$,null,null,null,null,true,$q$Use STAR with a concrete deadline.
Sample: "During our college fest, the registration portal broke a day before launch. I owned fixing it. I reproduced the bug, split the work with a teammate, tested after each fix, and kept the organisers updated. We launched on time with no major issues."
Mention how you stayed calm: breaking the problem into steps and communicating early.$q$),
($q$Cognizant$q$,$q$Theory$q$,$q$What is the difference between an abstract class and an interface in Java?$q$,null,null,null,null,false,$q$An abstract class can have both abstract and concrete methods, fields and constructors. A class can extend only one abstract class. Use it when related classes share state or common code.
An interface defines a contract (methods without implementation, although Java 8 and later allow default and static methods). A class can implement many interfaces. Use it to describe capabilities that unrelated classes can share.
Rule of thumb: "is-a" with shared code suggests an abstract class; "can-do" suggests an interface.$q$),
($q$Cognizant$q$,$q$Theory$q$,$q$How does HashMap work internally in Java?$q$,null,null,null,null,true,$q$HashMap stores key-value pairs in an array of buckets.
put(key, value): computes key.hashCode(), maps it to a bucket index and stores the entry there. If another key lands in the same bucket (a collision), entries are chained in a linked list.
get(key): finds the bucket from the hash, then uses equals() to find the right entry.
Since Java 8, a long chain (8 or more entries, with enough buckets) is converted to a balanced tree, improving worst-case lookup from O(n) to O(log n).
When size exceeds capacity times load factor (default 0.75), the table is resized and entries are rehashed.
Average get and put are O(1). Keys need consistent hashCode and equals.$q$),
($q$Cognizant$q$,$q$Behavioral$q$,$q$Why should we hire you?$q$,null,null,null,null,false,$q$Link your skills to what the role needs, with proof.
Sample: "I have a solid base in [language] and data structures, I built [project] end to end, and I learn quickly when something is new. I work well in a team and take responsibility for finishing tasks. I believe I can contribute early and grow with the company."
Be specific, confident and brief. Do not compare yourself to other candidates.$q$),
($q$Cognizant$q$,$q$Behavioral$q$,$q$Tell me about a project you are proud of.$q$,null,null,null,null,true,$q$Cover the problem, your role, the technology, a challenge and the result in about two minutes.
Sample: "I built a [what] to solve [problem]. I worked in a team of [n] and was responsible for [part]. We used [tech stack]. The hardest part was [challenge], which I solved by [approach]. The result was [measurable outcome]. If I did it again I would [improvement]."
Know every part of your own project, because interviewers often ask follow-up questions on your technology choices.$q$),
($q$Capgemini$q$,$q$Theory$q$,$q$What is the difference between a compiled and an interpreted language?$q$,null,null,null,null,false,$q$A compiled language is translated into machine code before running, by a compiler (C, C++). Execution is usually faster and many errors are found at compile time.
An interpreted language is executed line by line by an interpreter at run time (traditional Python, JavaScript). It is more flexible and easier to debug, but usually slower.
Some languages mix both: Java compiles to bytecode, which the JVM interprets or compiles just in time.$q$),
($q$Capgemini$q$,$q$Theory$q$,$q$Explain the TCP three-way handshake.$q$,null,null,null,null,true,$q$The three-way handshake sets up a reliable TCP connection.
1. SYN: the client sends a segment with the SYN flag and its initial sequence number.
2. SYN-ACK: the server replies with SYN and ACK, acknowledging the client's number and sending its own sequence number.
3. ACK: the client acknowledges the server's number. The connection is now established and data can flow.
It makes sure both sides are ready and agree on starting sequence numbers. Closing a connection uses FIN and ACK segments.$q$),
($q$Capgemini$q$,$q$Behavioral$q$,$q$Tell me about a time you failed. What did you learn?$q$,null,null,null,null,false,$q$Choose a real, modest failure, take ownership, and focus on what you changed afterwards.
Sample: "I did badly in a mock test because I spent too long on one question. I analysed my mistakes, started timing each section, and practised in timed sets. In my next test my score improved noticeably."
Do not blame others, and do not pick a failure that shows poor integrity.$q$),
($q$Capgemini$q$,$q$Behavioral$q$,$q$How do you prioritise when you have many tasks?$q$,null,null,null,null,true,$q$Explain your method, then give an example.
Sample: "I list all tasks, separate them by urgency and importance, and handle urgent and important ones first. I estimate time for each, check dependencies, and tell people early if something might slip. During exams and a project deadline, I used this to finish the project first, then study in blocks, and managed both."
Mentioning a tool such as a to-do list or calendar makes it more believable.$q$),
($q$HCLTech$q$,$q$Theory$q$,$q$What is the difference between TCP and UDP?$q$,null,null,null,null,false,$q$TCP is connection-oriented and reliable: it uses a handshake, acknowledgements, retransmission and ordering, with flow and congestion control. It is slower but dependable (web, email, file transfer).
UDP is connectionless, with no delivery guarantee or ordering. It is lightweight and fast (video calls, streaming, gaming, DNS).
Choose TCP when accuracy matters more than speed, and UDP when low latency matters and some loss is acceptable.$q$),
($q$HCLTech$q$,$q$Theory$q$,$q$What is virtual memory and paging?$q$,null,null,null,null,true,$q$Virtual memory lets a process use more memory than is physically available, by using disk as an extension of RAM. Each process sees its own address space.
Paging: memory is divided into fixed-size pages (virtual) and frames (physical). A page table maps pages to frames.
Demand paging: pages are loaded only when needed. If a page is not in RAM, a page fault occurs and the OS loads it from disk, replacing another page using an algorithm such as LRU or FIFO.
Too many page faults cause thrashing, which slows the system a lot.$q$),
($q$HCLTech$q$,$q$Behavioral$q$,$q$What motivates you?$q$,null,null,null,null,false,$q$Be authentic and link it to work.
Sample: "I am motivated by solving problems and seeing something I built actually work. In my project, fixing a hard bug and seeing users benefit gave me the best feeling. I am also motivated by learning from people who are better than me."
Avoid answers that are only about salary.$q$),
($q$HCLTech$q$,$q$Behavioral$q$,$q$Tell me about a time you took initiative.$q$,null,null,null,null,true,$q$Show you spotted a problem and acted without being asked.
Sample: "In our coding club, new members struggled with setup and nobody was responsible for helping them. I wrote a short setup guide and ran a one-hour session. Attendance rose and new members started contributing sooner."
Initiative means: notice, act, deliver, and share the result.$q$),
($q$Amazon$q$,$q$Theory$q$,$q$Compare arrays and linked lists.$q$,null,null,null,null,false,$q$Array: contiguous memory, O(1) random access by index, O(n) insertion or deletion in the middle (elements shift), fixed size or resizing cost, good cache locality.
Linked list: nodes connected by pointers, O(n) access, O(1) insertion or deletion when you already hold the node, dynamic size, extra memory for pointers, poor cache locality.
Use arrays for fast indexed reads. Use linked lists when frequent insertions and deletions at known positions matter.$q$),
($q$Amazon$q$,$q$Theory$q$,$q$How would you design a URL shortener?$q$,null,null,null,null,true,$q$Clarify requirements: shorten a long URL, redirect quickly, very high read volume.
API: POST /shorten (long URL returns a short code) and GET /{code} (redirect with HTTP 301 or 302).
ID generation: use a counter or distributed ID generator and encode it in base62 to get short codes. Seven characters give about 3.5 trillion combinations. Alternatively hash the URL and handle collisions.
Storage: a key-value or NoSQL store mapping code to URL, indexed by code.
Scale: cache popular codes in Redis or a CDN since reads far exceed writes, shard by code, and add rate limiting.
Extras: expiry, analytics, custom aliases.$q$),
($q$Amazon$q$,$q$Behavioral$q$,$q$Tell me about a time you put the customer first.$q$,null,null,null,null,false,$q$Amazon interviews use its Leadership Principles, so answer in STAR format and focus on the customer's benefit.
Sample: "While building a college app, users told me the search was confusing. My goal was to make it easier to use. I interviewed five users, simplified the filters and tested again. Task completion time dropped and feedback improved."
Make clear what you did (use "I"), and include numbers if you can.$q$),
($q$Amazon$q$,$q$Behavioral$q$,$q$Tell me about a time you disagreed with your team.$q$,null,null,null,null,true,$q$This tests the "Have Backbone; Disagree and Commit" principle. Show you challenged respectfully with data, then supported the final decision.
Sample: "My teammate wanted a complex framework for a simple project and I thought it would slow us down. I shared a comparison of effort and timeline and suggested a quick prototype. The team chose the simpler option. Had it gone the other way, I would have backed the decision fully."
Avoid stories where you simply won, or where you stayed silent.$q$),
($q$Zoho$q$,$q$Theory$q$,$q$Explain recursion with an example. What are its drawbacks?$q$,null,null,null,null,false,$q$Recursion is when a function calls itself to solve smaller versions of the same problem. It needs a base case (to stop) and a recursive case (moving toward the base case).
Example: factorial(n) = n * factorial(n - 1), with factorial(0) = 1.
Drawbacks: each call uses stack space, so deep recursion can cause stack overflow; it can be slower than loops; naive versions (like Fibonacci) repeat work, which memoisation or dynamic programming fixes.$q$),
($q$Zoho$q$,$q$Theory$q$,$q$What are a memory leak and a dangling pointer in C?$q$,null,null,null,null,true,$q$Memory leak: memory allocated on the heap (malloc or new) is never freed and no pointer to it remains, so the program's memory use keeps growing. Fix: free every allocation exactly once, and use RAII or smart pointers in C++.
Dangling pointer: a pointer that still refers to memory that has been freed or has gone out of scope (for example, returning the address of a local variable). Using it is undefined behaviour. Fix: set pointers to NULL after free and never return addresses of locals.
Related bugs: double free and buffer overflow.$q$),
($q$Zoho$q$,$q$Behavioral$q$,$q$Why do you want to work at a product company like Zoho?$q$,null,null,null,null,false,$q$Show you understand the difference between product and service work, and be honest.
Sample: "I want to work on software that real users use every day and own it from design to improvement. A product company lets me go deep into one codebase and see the impact of my work. I also enjoy building things from scratch, like [project]."
Read about the company's products before the interview and mention one.$q$),
($q$Zoho$q$,$q$Behavioral$q$,$q$Tell me about something you built on your own.$q$,null,null,null,null,true,$q$Product companies like to see self-driven building, so talk about something beyond coursework.
Sample: "I built a [what] because I wanted [personal reason]. I learnt [tech] on my own using documentation and tutorials. Along the way I faced [challenge] and solved it by [approach]. I put it on GitHub and [outcome]."
Be ready to explain the code, your design choices and what you would do differently.$q$),
($q$Tech Mahindra$q$,$q$Theory$q$,$q$What is the difference between SQL and NoSQL databases?$q$,null,null,null,null,false,$q$SQL (relational) databases store data in tables with a fixed schema and use SQL. They support joins and ACID transactions (MySQL, PostgreSQL). Best for structured data and complex queries.
NoSQL databases are non-relational with flexible schemas: document (MongoDB), key-value (Redis), column (Cassandra), graph (Neo4j). They scale out easily and suit large, changing or unstructured data.
Choose based on data structure, consistency needs and scale.$q$),
($q$Tech Mahindra$q$,$q$Theory$q$,$q$What is the difference between GET and POST? What makes an API RESTful?$q$,null,null,null,null,true,$q$GET requests data. It should not change anything (safe and idempotent), parameters go in the URL, and responses can be cached. POST sends data in the request body to create or process a resource, and it is not idempotent.
A RESTful API follows these ideas: resources identified by URLs (/users/5), standard HTTP methods (GET, POST, PUT, DELETE), stateless requests (each request carries all the information needed), a uniform interface, and proper status codes (200, 201, 404).$q$),
($q$Tech Mahindra$q$,$q$Behavioral$q$,$q$What do you know about our company?$q$,null,null,null,null,false,$q$Research before the interview: what the company does, its main services, recent news and the sectors it serves.
Sample: "Tech Mahindra is an IT services and consulting company with a strong presence in telecom and communications, and it works on areas like digital transformation. I am interested in [specific area] and would like to learn more about it."
Check the official website and recent news so your facts are accurate. If unsure, say less rather than guess.$q$),
($q$Tech Mahindra$q$,$q$Behavioral$q$,$q$How do you keep up with new technology?$q$,null,null,null,null,true,$q$Name specific habits.
Sample: "I follow a few trusted sources: official documentation, engineering blogs and a weekly newsletter. I build small projects to try new tools. Recently I learnt [topic] by [action]. I also discuss new ideas with friends in our coding group."
Mention something concrete you learned in the last few months.$q$),
($q$Deloitte$q$,$q$Theory$q$,$q$What is the difference between a primary key and a foreign key?$q$,null,null,null,null,false,$q$A primary key uniquely identifies each row in a table. It cannot be NULL or duplicated, and a table has only one.
A foreign key is a column that refers to the primary key of another table, creating a relationship and enforcing referential integrity (you cannot reference a row that does not exist). A table can have many foreign keys, and they can be NULL or repeated.
Example: Orders.CustomerID is a foreign key to Customers.CustomerID.$q$),
($q$Deloitte$q$,$q$Theory$q$,$q$What is a database index? What are its pros and cons?$q$,null,null,null,null,true,$q$An index is a data structure (usually a B-tree) that lets the database find rows quickly without scanning the whole table, like the index of a book.
Pros: much faster lookups, sorting and joins on indexed columns.
Cons: uses extra storage, slows INSERT, UPDATE and DELETE because the index must be updated, and too many indexes hurt performance.
Good candidates: columns used often in WHERE, JOIN and ORDER BY clauses with high selectivity. Primary keys are indexed automatically.$q$),
($q$Deloitte$q$,$q$Behavioral$q$,$q$Describe a time you showed leadership.$q$,null,null,null,null,false,$q$Leadership does not need a title. Show how you guided others toward a goal.
Sample: "I led a four-member team in a hackathon. We had 24 hours to build a working prototype. I split the work by strengths, set checkpoints every few hours, and helped a teammate who was stuck. We finished on time and presented a working demo."
Focus on how you enabled others, not only on what you did yourself.$q$),
($q$Deloitte$q$,$q$Behavioral$q$,$q$Tell me about a time you explained something complex to a non-technical person.$q$,null,null,null,null,true,$q$Client communication is a big part of consulting. Show that you can simplify.
Sample: "I had to explain our project's database design to a non-technical faculty member who needed to approve it. I used an everyday analogy, comparing tables to registers in an office, with a simple diagram, then checked her understanding with questions. She approved it and later asked for the diagram again."
Key skills: analogies, avoiding jargon, visuals, and checking understanding.$q$),
($q$LTIMindtree$q$,$q$Theory$q$,$q$What is the difference between == and equals() in Java?$q$,null,null,null,null,false,$q$For objects, == compares references (whether both variables point to the same object). For primitives, it compares values.
equals() compares logical content. The default Object.equals() behaves like ==, but classes such as String override it to compare characters.
Example: new String("hi") == new String("hi") is false, while the equals() comparison is true.
If you override equals(), also override hashCode() so hash-based collections work correctly.$q$),
($q$LTIMindtree$q$,$q$Theory$q$,$q$Explain exception handling in Java. What are checked and unchecked exceptions?$q$,null,null,null,null,true,$q$An exception is an event that disrupts normal program flow. Java handles it with try, catch, finally, throw and throws.
Checked exceptions (for example IOException, SQLException) are verified at compile time: you must catch them or declare them with throws.
Unchecked exceptions (RuntimeException and its subclasses such as NullPointerException) are not checked at compile time and usually come from programming errors.
Errors (for example OutOfMemoryError) are serious problems you generally should not catch.
finally runs whether or not an exception occurs, so it is used for cleanup. try-with-resources closes resources automatically.$q$),
($q$LTIMindtree$q$,$q$Behavioral$q$,$q$Tell me about your final-year project.$q$,null,null,null,null,false,$q$Explain it simply in about two minutes: problem, solution, your role, technology, result.
Sample: "Our final-year project is a [what], built to solve [problem]. I handled [module] using [technology]. A challenge was [challenge], which I solved by [approach]. The result is [outcome], and a future improvement would be [idea]."
Prepare for follow-ups on design choices, the database schema and testing.$q$),
($q$LTIMindtree$q$,$q$Behavioral$q$,$q$How do you handle feedback or criticism?$q$,null,null,null,null,true,$q$Show you listen, do not get defensive, and act on it.
Sample: "I see feedback as free advice. When my mentor told me my code was hard to read, I first made sure I understood the examples, then started using clearer names and shorter functions, and asked for a second review. The next review had far fewer comments."
Avoid saying you never get criticism, and do not blame the person giving it.$q$);
