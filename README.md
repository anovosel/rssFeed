# RSS Feed
Simple application for adding and viewing RSS Feeds

## Assignment
Create an applicatin where user can add/update/delete RSS Feeds. Added Feeds can be opened (show list of items and opened in external browser).

## Motivation
Solution is used to demonstrate:
- understanding and ability to use Clean Architecure with MVVM
- usage of Cocoapods and SPM
- configuring application with TabBar navigation
- simple usage of CoreData
- using SnapKit to define view constraints from code 
- custom Table and Collection View Cells
- SDWebImage for loading and cashing images
- Combine for connecting View and ViewModel
- protocol oriented programming

## Solution Preview
https://github.com/user-attachments/assets/39aa68a7-7811-4647-b01f-9da92317fe2b

## Future Improvements
- input validation
- connect input fields using Combine for validation
- ~~validate input before saving~~ -> implemented [here](https://github.com/anovosel/rssFeed/pull/1)
- there is a difference when oppening Bottom sheet for editing existing and for adding new feed
- using loaders, and feedback messages for better UX
- error handling
- using Coordinators for navigation between view controllers
