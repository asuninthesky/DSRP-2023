## set your name and email
usethis::use_git_config(user.name = "Adrian Sun", user.email = "02asun21@gmail.com")

##create a personal access token (PAT) for authentication
usethis::create_github_token()

## set personal access token
#credentials::set_github_pat("") deleted the key 
