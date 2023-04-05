# **cloudflare-api-DNS-dynamic-ip**

![GitHub last commit](https://img.shields.io/github/last-commit/DanielBatesUK/cloudflare-api-dns-dynamic-ip) ![GitHub repo file count](https://img.shields.io/github/directory-file-count/DanielBatesUK/cloudflare-api-dns-dynamic-ip) ![GitHub repo size](https://img.shields.io/github/repo-size/DanielBatesUK/cloudflare-api-dns-dynamic-ip) ![GitHub issues](https://img.shields.io/github/issues-raw/DanielBatesUK/cloudflare-api-dns-dynamic-ip)

![GitHub forks](https://img.shields.io/github/forks/DanielBatesUK/cloudflare-api-dns-dynamic-ip?style=social)

![Twitter Follow](https://img.shields.io/twitter/follow/DanielBatesUK?style=social)

## Description

A simple Bash script that updates an DNS A record on Cloudflare with the current IP address. Good for hosts with dynamic ip addresses.

## Installation

### Clone the repository

Clone the cloudflare-api-DNS-dynamic-ip repo from GitHub.

```Shell
git clone https://github.com/DanielBatesUK/cloudflare-api-dns-dynamic-ip
```

Then, move to the clone's root directory and give the script execute permissions

```Shell
chmod +x cloudflare-dns-update.sh
```

### Create a Cloudflare API Token

On the Cloudflare dashboard, go to the 'overview' page of the website you want to update. On the column on the right, they will be a API section. Grab a copy and make a note of the 'Zone ID' as you'll be needing this later. And, then click 'Get your API token'.

In the 'API Tokens' section, click on the 'Create Token' button. Then click on the 'Edit zone DNS' from the 'API token templates' list. Then, set your permissions accordingly. You might want to limit the 'Zone Resources' to 'Include','Specific Zone','[your-website]'. And finally, click on the 'Continue to summary' button.

Review all is correct and click the 'Create Token' button.

Grab a copy of the api token too as you'll be needing this later; along with the Zone ID from earlier.

### Updating the script

> I recommend copying the script file and rename it to something that represents the DNS record you intend to update. This comes in handy if you're updating multiple records. For example: `cp cloudflare-dns-update.sh example.com.sh`. However, I'll be using the original name for the rest of these instructions.

You'll need to update your script file. In these instructions I'll be using nano.

```Shell
nano cloudflare-dns-update.sh
```

Update the following

- `[CLOUDFLARE-API-TOKEN-HERE]` Change this to the api token you created earlier.
- `[CLOUDFLARE-ZONE-ID-HERE]` Change this to the Zone ID you noted previously from the website overview dashboard.

That's it for now. Save the file <kbd>Ctrl</kbd>+<kbd>O</kbd> then <kbd>Enter</kbd>. And exit nano with <kbd>Ctrl</kbd>+<kbd>X</kbd>.

#### Getting your DNS record ID

Now it's important to note, this script only updates records. It doesn't create them. So if the DNS record that you want to update doesn't exist already; then you'll need to create it now via your website's dashboard on Cloudflare.

For example, add an A record for your host to a temporary ip `A  @  192.0.2.1`.

Once this is done. you can then run the script with a `list` parameter.

```Shell
./cloudflare-dns-update.sh list
```

This should create new a file called `cloudflare-dns-update_dnslist.json`.

You need to retrieve the 'id' from the DNS list JSON for the DNS record you want to update. 

Now this JSON file isn't easy to read. So I'd recommend installing 'jq' if you don't already have it.

```Shell
sudo apt-get install jq
```

Then use it to pretty the JSON.

```Shell
jq . cloudflare-dns-update_dnslist.json
```

Copy and note down the id string of the DNS record you want to update.

#### Finish updating the script

Edit the script file again

```Shell
nano cloudflare-dns-update.sh
```

This time update the following

- `[cloudflare-dns-RECORD-ID-HERE]` Change this to DNS record id you noted.

Then change the rest of the DNS settings variables to match your desired DNS record settings. In particular 'TYPE' and 'NAME'. 'TYPE' should stay as `"A"`. This is because we are updating the record with an ip address. 'NAME' should be `"@"` for host root or the name of your subdomain (in quotes). Leave 'CONTENT' alone, this will update the DNS record with the host's current web ip address. Set 'PROXIED' to either `"true"` or `"false"` depending on your requirements (keep it in quotes this a string). And finally change 'TTL' to your required time-to-live integer (a number no quotes - default: 1).

That's it. Save the file <kbd>Ctrl</kbd>+<kbd>O</kbd> then <kbd>Enter</kbd>. And exit nano with <kbd>Ctrl</kbd>+<kbd>X</kbd>.

### Run the script

> Before running the script, I recommend manually changing the DNS record you'll be updating via the Cloudflare dashboard; and point it to a temporary ip. For example `192.0.2.1`. This will help to see if the script is running correctly later.

Run the script (with no parameters)

```Shell
./cloudflare-dns-update.sh
```

This should update your DNS record and create new a file called `cloudflare-dns-update_results.json`.

Check your Cloudflare dashboard, to see if your website's DNS record has been updated; to reflect your host's web ip address. 

If it hasn't then check the results JSON file for errors.

### Add to crontab

Once you know that your script is working fine. You need to keep your DNS record constantly up-to-date with your host's dynamic ip address. So you will need to regularly run the script. You can do this by adding the script to your crontab to run the script automatically at specified intervals.

Edit your crontab.

```Shell
sudo contab -e
```

_You maybe prompted for what editor you want to use. Just choose your preferred option._

On a new line enter the following

```Shell
*/1 * * * * /path/to/your/script/cloudflare-dns-update.sh
```

_Make sure to change the path in the line above to where your script is saved._

The line above will execute the script once ever minute. Amend the `*/1 * * * *` part of the line, if you'd like to change how often the script should run. Look up cron documentation or visit [Crontab.guru](https://crontab.guru/#*/1_*_*_*_*) for help.

Save the file, if you're using nano with crontab then <kbd>Ctrl</kbd>+<kbd>O</kbd> then <kbd>Enter</kbd>. And exit nano with <kbd>Ctrl</kbd>+<kbd>X</kbd>.

After exiting, you should see `crontab: installing new crontab`.

> To check this is working, manually edit the DNS record via your website's Cloudflare dashboard, and set to a temporary ip address (192.0.2.1). Then try refreshing the dashboard page after the your crontab interval, and check that the ip address has been updated.

### Also consider

If you are just hosting web traffic (HTTP & HTTPS). Rather than running a script like this, you should consider configuring a Tunnel via your Cloudflare Zero Trust dashboard and installing 'cloudflared' on your host.

## Author

### **Daniel Bates**

- Github: [@DanielBatesUK](https://github.com/DanielBatesUK)
- Twitter: [@DanielBatesUK](https://twitter.com/DanielBatesUK)
- LinkedIn: [@DanielBatesUK](https://linkedin.com/in/DanielBatesUK)

## License

- Copyright © 2022 [Daniel Bates](https://github.com/DanielBatesUK).
- This project is [GNU v3.0](https://github.com/DanielBatesUK/cloudflare-api-dns-dynamic-ip/blob/c57a76e55ad50b386ce96a26994c4a3743e3aaa8/LICENSE) licensed.
