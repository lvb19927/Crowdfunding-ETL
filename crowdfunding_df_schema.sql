CREATE TABLE "campaign" (
	"cf_id" int NOT NULL,
	"contact_id" int NOT NULL,
	"company_name" varchar(100) NOT NULL,
	"description" text NOT NULL,
	"goal" numeric(10,2) NOT NULL,
	"pledged" numeric(10,2) NOT NULL,
	"outcome" varchar(10) NOT NULL,
	"backers_count" int NOT NULL,
	"country" varchar(10) NOT NULL,
	"currency" varchar(10) NOT NULL,
	"launched_date" date NOT NULL,
	"end_date" date NOT NULL,
	"category_id" varchar(10) NOT NULL,
	"subcategory_id" varchar(10) NOT NULL,
	CONSTRAINT "pk_campaign" PRIMARY KEY (
		"cf_id"
	)
);

CREATE TABLE "contacts" (
	"contact_id" int NOT NULL,
	"first_name" varchar(50) NOT NULL,
	"last_name" varchar(50) NOT NULL,
	"email" varchar(100) NOT NULL,
	CONSTRAINT "pk_contacts" PRIMARY KEY (
		"contact_id"
	)
);

CREATE TABLE "category" (
	"category_id" varchar(10) NOT NULL,
	"category_name" varchar(50) NOT NULL,
	CONSTRAINT "pk_category" PRIMARY KEY (
		"category_id"
	)
);
--DROP TABLE "subcategory"
CREATE TABLE "subcategory" (
	"subcategory_id" varchar(10) NOT NULL,
	"subcategory_name" varchar(50) NOT NULL,
	CONSTRAINT "pk_subcategory" PRIMARY KEY (
		"subcategory_id"
	)
);

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_contact_id" FOREIGN KEY("contact_id")
REFERENCES "contacts" ("contact_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_category_id" FOREIGN KEY("category_id")
REFERENCES "category" ("category_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_subcategory_id" FOREIGN KEY("subcategory_id")
REFERENCES "subcategory" ("subcategory_id");

--DROP TABLE backers;
CREATE TABLE "backers" (
	"backer_id" varchar(10) NOT NULL,
	"cf_id" int NOT NULL,
	"first_name" varchar(50) NOT NULL,
	"last_name" varchar(100) NOT NULL,
	"email" varchar(100) NOT NULL,
	CONSTRAINT "pk_backers" PRIMARY KEY (
		"backer_id"
	)
);

ALTER TABLE "backers" ADD CONSTRAINT "fk_backers_cf_id" FOREIGN KEY("cf_id")
REFERENCES "campaign" ("cf_id");

SELECT *
FROM backers
LIMIT 10;

SELECT * FROM backers;

SELECT cf_id,
		backers_count
FROM campaign
WHERE outcome = ('live')
ORDER BY backers_count DESC;

SELECT b.cf_id,
		COUNT(b.backer_id) AS "backers_count"
FROM backers AS b
INNER JOIN campaign AS c
ON b.cf_id = c.cf_id
WHERE c.outcome = 'live'
GROUP BY b.cf_id
ORDER BY "backers_count" DESC;

SELECT b.first_name,
	b.last_name,
	b.email,
	c.goal - c.pledged AS "Remaining Goal Amount"
INTO email_contacts_remaining_goal_amount
FROM contacts AS b
LEFT JOIN campaign AS c
ON b.contact_id = c.contact_id
WHERE c.outcome = 'live'
ORDER BY "Remaining Goal Amount" DESC;

SELECT *
FROM email_contacts_remaining_goal_amount
LIMIT 10;

SELECT b.email,
	b.first_name,
	b.last_name,
	b.cf_id,
	c.company_name,
	c.description,
	c.end_date,
	c.goal - c.pledged AS "Left of Goal"
INTO email_backers_remaining_goal_amount
FROM backers AS b
INNER JOIN  campaign AS c
ON b.cf_id = c.cf_id
ORDER BY last_name;


-- Check the table

SELECT *
FROM email_backers_remaining_goal_amount
LIMIT 10;

