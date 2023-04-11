# **cloudflare-api-dns-dynamic-ip**

![GitHub last commit](https://img.shields.io/github/last-commit/DanielBatesUK/cloudflare-api-dns-dynamic-ip) ![GitHub repo file count](https://img.shields.io/github/directory-file-count/DanielBatesUK/cloudflare-api-dns-dynamic-ip) ![GitHub repo size](https://img.shields.io/github/repo-size/DanielBatesUK/cloudflare-api-dns-dynamic-ip) ![GitHub issues](https://img.shields.io/github/issues-raw/DanielBatesUK/cloudflare-api-dns-dynamic-ip)

![GitHub forks](https://img.shields.io/github/forks/DanielBatesUK/cloudflare-api-dns-dynamic-ip?style=social)

![Twitter Follow](https://img.shields.io/twitter/follow/DanielBatesUK?style=social)

## Description

A simple Bash script that updates a DNS record on Cloudflare with the host's current web IP address. Good for hosts with dynamic IP addresses.

## Instructions

It looks like there's a lot to do here. But in reality these instructions should only take a minute or two to complete. TL;DR: Download the script, create a Cloudflare API token, update the script with the token and zone id, find your Cloudflare DNS record's id, update the script again with the id and dns settings, and add to crontab. 

### Prerequisite: Install cURL

For this script to work you will need to have cURL installed. If you don't have it installed, run this command to install it.

```Shell
sudo apt-get install curl
```

### Download the script

#### _Either:_ Clone the repository

Clone the cloudflare-api-dns-dynamic-ip repo from GitHub.

```Shell
git clone https://github.com/DanielBatesUK/cloudflare-api-dns-dynamic-ip
```

#### _Or:_ Just download the script

Move to the directory where you want to save the file. Then run the following command.

```Shell
wget https://raw.githubusercontent.com/DanielBatesUK/cloudflare-api-dns-dynamic-ip/main/cloudflare-dns-update.sh
```

#### Give the script execute permissions

Move to the clone's root directory, or to the directory where you downloaded the file, and then give the script execute permissions.

```Shell
chmod +x cloudflare-dns-update.sh
```

### Create a Cloudflare API Token

#### Get your 'Zone ID'

On the Cloudflare dashboard, go to the 'overview' page of the website you want to update. On the column on the right, there will be a section labelled 'API'. Copy and make a note of the 'Zone ID' as you'll be needing this later. And then, click on the 'Get your API token' link.

#### Creating a token

1. In the 'API Tokens' section, click on the 'Create Token' button. 
2. On the next page, click on the 'Use Template' button for 'Edit zone DNS'; from the 'API token templates' list.
3. Give your token a name (pencil icon) and set your permissions accordingly. You might want to limit the 'Zone Resources' to 'Include', 'Specific Zone', '[your-website.com]'. Especially if you are looking after multiple domains. This will help limit the damage to only one website, in the event your API tokens and zone ids get accidentally leaked. 
4. Then click the 'Continue to summary' button.
5. Review all the settings in summary and make sure everything is correct. Then click the 'Create Token' button.

#### Get your API token

Copy and note down the API token as you'll be needing this later; along with the 'Zone ID' from earlier. If you lose this API token, then you will have to 'Roll' a new one, via the 3 dot options button for your token, on the 'API Tokens' page, of your 'My Profile' dashboard.

### Updating the script

> Before we update the script, I recommend copying the script file and renaming it; to something that represents the DNS record you intend to update. This comes in handy if you're updating multiple records with multiple scripts. For example: `cp cloudflare-dns-update.sh example.com.sh`. However, I'll be using the original name for the rest of these instructions.

#### Edit the script file

You'll need to edit and update your script file. In these instructions I'll be using nano.

```Shell
nano cloudflare-dns-update.sh
```

#### Adding your API Token and Zone ID to the script

Update the following _Cloudflare API token and Website Zone ID_ variables.

- `TOKEN="CLOUDFLARE-API-TOKEN-HERE"` Replace `CLOUDFLARE-API-TOKEN-HERE` with the API token you created earlier (it's a string so keep it within quotes).
- `ZONEID="CLOUDFLARE-ZONE-ID-HERE"` Replace `CLOUDFLARE-ZONE-ID-HERE` with the 'Zone ID' you noted previously; from the website overview dashboard (again, it's a string, so keep it within quotes).

#### Save the script file

That's it for now. Save the file <kbd>Ctrl</kbd>+<kbd>o</kbd> then <kbd>Enter</kbd>. And then exit nano with <kbd>Ctrl</kbd>+<kbd>x</kbd>.

### Getting your DNS record's ID

> Now it's important to note, this script only updates existing records. It does not create new records. So if the DNS record that you want to update doesn't exist; then you'll need to create it now; via your website's dashboard on Cloudflare. For example, add an 'A' record for your host, pointing towards a temporary IP address `A  @  192.0.2.1`.

#### Run the script with '--get-dns' parameter

To update your DNS record, you will need to know the specific record's 'id'. As far as I know, this 'id' isn't listed anywhere on the dashboard. But we can look it up using this script with the '--get-dns' parameter.

```Shell
./cloudflare-dns-update.sh --get-dns
```

This should output the JSON response from Cloudflare and create a new DNS JSON file called `cloudflare-dns-update_dns.json`.

#### Find your DNS record's 'id'

You'll need to lookup the 'id' for the DNS record you want to update, either from the response on your terminal or from the \_dns.json file. 

Now, I know, this JSON output isn't very easy to read. So I'd recommend installing 'jq' if you don't already have it.

```Shell
sudo apt-get install jq
```

Then use it on the \_dns.json file to pretty the JSON; making it much-much easier to read.

```Shell
jq . cloudflare-dns-update_dns.json
```

Find the DNS record you want to update, then copy and note down the 'id' string.

### Update your DNS record

#### Finish updating the script

Once you have the DNS record's 'id', you'll need to edit and update the script file again.

```Shell
nano cloudflare-dns-update.sh
```

This time update the following _DNS Record ID_ variable.

- `DNSID="CLOUDFLARE-DNS-RECORD-ID-HERE"` Replace `CLOUDFLARE-DNS-RECORD-ID-HERE` with the DNS record 'id' you noted from the JSON response earlier (within quotes).

Then finally change the _DNS record settings_ variables to match your requirements. In particular the 'NAME' variable.

- `NAME="@"` should be set to the name of your record. For example `"@"` for host root, maybe `"www"`, or the name of your subdomain (in quotes).
- `PROXIED="true"` must be set to either `"true"` or `"false"`; depending on your requirements (keep it in quotes as this is a string and not a boolean).
- `TTL=1` should be set to your required time-to-live integer (a number with no quotes - default=1).

That's it; you're done. Save the file <kbd>Ctrl</kbd>+<kbd>o</kbd> then <kbd>Enter</kbd>. And exit nano with <kbd>Ctrl</kbd>+<kbd>x</kbd>.

### Run the script

> Before running the script, I recommend manually changing the DNS record you'll be updating via the Cloudflare dashboard; and point it to a temporary IP address. For example `192.0.2.1`. This will help you see if the script is running correctly later.

Run the script (with no parameters)

```Shell
./cloudflare-dns-update.sh
```

This should update your DNS record, output the response from Cloudflare in your terminal and create new a results JSON file called `cloudflare-dns-update_results.json`.

Check your Cloudflare dashboard, to see if your website's DNS record has been updated; to reflect your host's web IP address. 

If the DNS record hasn't updated. Then check the results JSON for errors.

```Shell
jq . cloudflare-dns-update_results.json
```

### Add to crontab

Once you know that your script is working. You'll need to keep your DNS record constantly up-to-date with your host's dynamic web IP address. So you will need to run this script regularly. You can do this by adding the script to your crontab. This will run the script automatically at specified intervals.

Edit your crontab.

```Shell
sudo crontab -e
```

_You maybe prompted for what editor you want to use. Just choose your preferred option._

On a new line enter the following

```Shell
*/1 * * * * /path/to/your/script/cloudflare-dns-update.sh
```

_Making sure to change the path in the line above to where your script is saved._

The line above will execute the script once every minute. Amend the `*/1 * * * *` part of the line, if you'd like to change how often this script should run. Look up cron documentation or visit [Crontab.guru](https://crontab.guru/#*/1_*_*_*_*) for help.

Save the file and exit. If you're using nano with crontab then <kbd>Ctrl</kbd>+<kbd>o</kbd>, then <kbd>Enter</kbd>, and exit with <kbd>Ctrl</kbd>+<kbd>x</kbd>.

After exiting, you should see `crontab: installing new crontab`.

> To check this is working, manually edit the DNS record via your website's Cloudflare dashboard, and either set to a temporary IP address `192.0.2.1` or you could set the 'Proxy Status' to the opposite of your requirements. Then try refreshing the dashboard page after the your crontab interval, and check that the DNS record has been updated. You should also notice that the modified time for the results JSON file will be updated too. 

## Also consider

If you are just hosting web traffic (HTTP & HTTPS). Rather than running a script like this, you should maybe consider configuring a tunnel via your Cloudflare Zero Trust dashboard and installing 'cloudflared' on your host.

## Author

### **Daniel Bates**

- GitHub: [@DanielBatesUK](https://github.com/DanielBatesUK)
- Twitter: [@DanielBatesUK](https://twitter.com/DanielBatesUK)
- LinkedIn: [@DanielBatesUK](https://linkedin.com/in/DanielBatesUK)

## License

- Copyright © 2023 [Daniel Bates](https://github.com/DanielBatesUK).
- This project is [GNU v3.0](https://github.com/DanielBatesUK/cloudflare-api-dns-dynamic-ip/blob/c57a76e55ad50b386ce96a26994c4a3743e3aaa8/LICENSE) licensed.
