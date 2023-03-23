# GitForOps - TODO - This is the outline from previous content, needs to be reviewed and revised

## Why Git?

## Scope

## Outline

**Need working tree**

### Intro - Why Git?

I'm not a developer! Okay, do you write a script on your machine (or a machine, server, etc) to automate something or to tell that machine to do something for you? Then yes, you are a developer. Whether you're an ITPro, operations specialist, sys admin, whatever...you are also doing some development. The systems you work on, do not disqualify you from this. You just develop code for infrastructure. Regardless, as an operations professional, we are ingratiated into our jobs with certain tools, for some time we have seen certain tools for 'developers' or 'programmers'.  For those of us working in operations, these tools have not been part of our day to day job.

For many of us, we have tasks that we perform on a daily basis, or we automate things in our environments to remove mundane tasks, or make tasks repeatable. I want to challenge you as an ITPro to start thinking about how we can be proactive in our jobs, not reactive. 

I walked into work one Tuesday morning and my colleague who managed the SharePoint server farm passed away very unexpectedly. The mood in the office was extremely somber, although the reality is, we had to run a business. We had a single human performing tasks and a job that was not repeatable.  We had over 200 retail stores relying on us, the IT team, to keep the lights on. I was tasked with taking on the SharePoint server farm management from that moment. 

In another scenario, I perform similar tasks repetitively, the company relies on me to do these tasks and it's how I justify my job. When something breaks, I am the expert, they rely on my knowledge to get by. This is a mindset that we need to let go of. We need to think of how we, as experts, can be proactive. We also need to work with the other technical teams to work together, break down the silos in organization and stop blaming each team for the failures in the infrastructure and its reliability. We need to work together as a team. Whether we are managing infrastructure that is located in our own datacenters, or someone elses, we need to look at how and why we perform our day to day jobs. 

When working with customers that want to take that leap to the cloud, they see it as an opportunity to do things better. There is still an on-prem presence of infrastructure, we still need to keep the lights on. Whether we're running physical servers, virtual machines or consuming a Platform as a Service (PaaS), we need to think how we can do things better.

I wish we could automate all the things, we can, to an extent. More importantly we need to make sure that we can take a day off work and ensure we aren't leaving single points of failure, automate tasks that allow us as IT Professionals to focus on proactive work, reduce the human error element. This is a great time to look at our tooling, which will affect our day to day working practices (for the better) and in effect assist us with a cultural change within our team and our organization. Change is hard. 

We are going to look at Git and why as IT Pros we should be using it. 

Tell a story here, find a technical use case: I wrote this script or did this thing, then deployed it. I kept my script to myself, on my computer. No one else can use my script unless I share it. If they change it, then I won't know. No testing... control. Too many oopsies

Story: I deployed this thing and it broke. Finger pointing. Triage. Set and forget a task.

Version Control: it shows you a file and the history of that file, the journey of that file. You know when someone edits your document? Or you lost those changes? Or you're collaborating with someone and you version the files, then lose track? Or forget to save it? Example of 'Previous versions' in Word/Excel, etc. 

Real life example: 

We work in systems, which include processes (think about DevOps - process!)

  #### 

### What is Git?
  - Benefits/Features
    - Version Control, Traceability, collaboration, transparency in work, track issues, code reusability
    - Show how Git stores data and works - Flow of work
     

  - Basic Git Terms
    - working tree
    - repositor (repo)
    - Hash
    - remote
    - commans, subcommands and options
      - Snapshot
      - Commit
      - repository
      - Head
      - branches
      - rebasing
    -  Branching and branching strategies
  -  Pull Requests
  -  Pull vs Push
  -  Merge requests
    
    
    -Intro to other tools? --Showing auth from VS Code to Git
        - Command line vs GH Desktop
        - 

    
Intro - GH
    -What is GH?
    -GH features
        *Collaboration — Helps to work in team
        Version Maintenance — Keep track of your code
        Transparency in work — Detailed history of every commit
        Track issues — Helps a lot in verification and validation
        Code reusability
        Enterprise grade security
    - Setup GH Account
    - Walk around the dashboard
    - Setup GH/Git auth?
    
Create Your first Repo
    - Create a new repo
    - Clone repo into VS Code from GH
    - Init an exist project
    
  -Setup Git on Win/Mac
        *VSCode
        *Codespaces
        *SSH vs HTTPS auth
        *IDentity - global identity


### References
https://git-scm.com/book/en/v2