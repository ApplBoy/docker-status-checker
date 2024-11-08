# docker-status-checker
A simple cron checker for docker status, with the alert sent to Discord Webhook.

## Dependencies:

- curl
- docker

## Installation

Clone the git and make it executable.

```sh
git clone https://github.com/ApplBoy/docker-status-checker.git
cd docker-status-checker
chmod +x check-status.sh
su $NON_ROOT_USER -c 'crontab -e'
```

Edit it, inserting the Webhook URL into `token`.
Create a file `containers-id.list`, and insert into each line the Container ID which you want to be checked.

Then insert the crontab instance to check every 5 minute:

```
0/5 * * * * $PWD/check-status.sh
```

For a standard instance, use:

```
0,5,10,15,20,25,30,35,40,45,50,55 * * * * $PWD/check-status.sh
```

