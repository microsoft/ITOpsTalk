# Adding the cm-resource-parent tag to all resources in a resource group 

**Note**: This sample is part of the blog post [The Parent Tag: cm-resource-parent for Azure cost management](https://techcommunity.microsoft.com/t5/itops-talk-blog/the-parent-tag-cm-resource-parent-for-azure-cost-management/ba-p/3727771?WT.mc_id=modinfra-84861-socuff)

The cm-parent-resource tag can be used by Azure's Cost Management (preview) view, to more effectively roll up the cost of different resources that are associated with the same solution or virtual machine. For examples of what this looks like, check out the blog post linked above. 

The [cm-resource-parent.ps1](cm-resource-parent.ps1) file in this folder contains a script for adding this tag to all of the resources in one resource group, with the value of the resource ID of a particular Virtual Machine in that resource group. This is useful for including the cost of other VM components like additional data disks etc.

Feel free to use this script - or suggest an improvement!

## What does the script do?

The script specifies the name of a virtual machine and a resource group, which you will need to change to match your own environment.
It fetches the resource ID of that VM, then it adds the cm-parent-resource tag with that resource ID value to each of the resources in the resource group.
This tag addition preserves any exist tags on the resources.

**Note** After the tag is added, it can take 24 hours for the rolled-up cost data to appear.  
