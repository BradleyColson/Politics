- [Political_Contribution](#Political_Contribution)
  
- [Voting](#Voting)

# Political_Contribution

# Project: Political Contribution Analysis (FEC)

The Challenge: I wanted to see who was actually funding the 2020 election in New Hampshire. I pulled 52,000 rows of raw donor data from the FEC, but it was "dirty"—legacy encoding issues (UTF-8 BOM) and non-standard date formats meant I couldn't just plug it into MySQL.

What I did:

Wrangled the Data: I used PowerShell to fix line endings and encoding so the data would actually ingest.

Built the Schema: I designed a MySQL staging environment to handle the initial bulk load, then used STR_TO_DATE and DECIMAL casting to turn messy strings into usable data types.

Segmented the Donors: I wrote queries to group 51,523 contributions into "brackets" to see if the money was coming from grassroots supporters or high-net-worth individuals.

My Big Takeaway: The data showed a massive "Donation Gap." Even though 70% of people gave small amounts (under $200), the top 1% of donors (Max/High bracket) contributed just as much money in total. It really highlighted the concentration of financial influence at the top.




### The Top 10 donors

| Contributor | Employer | Occupation | Amount |
| :--- | :--- | :--- | :--- |
| **Forward Movement Foundation** | N/A | N/A | $1,000,000 |
| **Kohn, Victor** | Retired | Retired | $500,000 |
| **Portage Capital LLC** | N/A | N/A | $500,000 |
| **Schlaepfer, Walter P.** | JP Morgan | Wealth Advisor | $443,000 |
| **Schlaepfer, Lesli A.** | Homemaker | Homemaker | $443,000 |
| **Rydin, Michael T.** | Retired | Retired | $275,000 |
| **Huang, Matt** | Paradigm Operations LP | Managing Partner | $250,000 |
| **Oppenheimer, Gregg** | Self-Employed | Writer/Consultant | $150,000 |
| **IBEW PAC Educational Fund** | N/A | N/A | $100,000 |
| **Palmedo, Alana** | Paradigm | Managing Partner | $100,000 |

### The Top 10 funding hot spots geographically
| State | City | Total State Funds | Average Donation |
| :--- | :--- | :--- | :--- |
| **VA** | SPRINGFIELD | $1,002,367 | $55,687.06 |
| **NY** | NEW YORK | $926,382 | $671.29 |
| **WA** | BELLEVUE | $893,714 | $12,587.52 |
| **DC** | WASHINGTON | $673,036 | $473.30 |
| **CA** | ENCINO | $544,824 | $77,832.00 |
| **TX** | HOUSTON | $427,820 | $557.78 |
| **CA** | WOODSIDE | $252,008 | $19,385.23 |
| **IL** | CHICAGO | $231,869 | $434.21 |
| **CA** | SAN FRANCISCO | $230,306 | $719.71 |
| **TN** | KNOXVILLE | $200,332 | $1,804.79 |


<img width="1917" height="741" alt="Political_Donations" src="https://github.com/user-attachments/assets/bab755ab-a53e-4ede-a3b3-be4dc4344547" />


### Donor distribution



#### **Donor Contribution Distribution**
This table represents a segmented analysis of **51,523** individual contributions, identifying the relationship between donation volume and total financial impact.

| Donor Bracket | Donation Count | Total Value |
| :--- | :---: | :--- |
| **Small ($0-$199)** | 36,357 | $7,196,100 |
| **Medium ($200-$1000)** | 14,112 | $5,098,530 |
| **Large ($1001-$2900)** | 524 | $996,838 |
| **Max/High (>$2900)** | 530 | $7,246,166 |

---

### **Analytical Insights**
* **Volume vs. Value:** While the **Small ($0-$199)** bracket accounts for **70.5%** of all individual donations, the **Max/High** bracket (less than 1% of donors) contributed a nearly identical total dollar amount.
* **The "Donation Gap":** There is a significant drop-off in the **Large ($1001-$2900)** category, suggesting donors typically remain in the grassroots tier or jump directly to the maximum allowable contribution.
* **Data Integrity:** All values were cleaned and validated using SQL `STR_TO_DATE` and `DECIMAL` casting after resolving legacy encoding issues from the raw FEC source files.

### Key Data Insights
Grassroots Strength: 70% of all contributors fall into the Small ($0-$199) bracket, showing a broad base of support.

Top-Heavy Funding: The Max/High group contains only 1% of the total number of donors but accounts for roughly 35% of the total funds raised.

Engagement Gap: There is a noticeable "valley" in the Large ($1001-$2900) bracket, suggesting that donors are either casual contributors or "all-in" maximum donors, with very few in between.

### Technical Process (ETL)
A significant portion of this project involved overcoming "dirty data" challenges common in legacy government datasets:

Encoding Fixes: Resolved UTF-8 BOM and Windows-specific line ending issues using PowerShell to ensure 100% data ingestion into MySQL.

Schema Design: Developed a flexible staging table using BIGINT and VARCHAR to prevent data loss during the initial LOAD DATA INFILE process.

Data Transformation: Utilized STR_TO_DATE functions to convert non-standard MMDDYYYY strings into ISO-standard SQL DATE objects for time-series readiness.



