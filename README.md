# cardano-version

This script checks if the latest cardano-node version is installed, and provides metrics to prometheus node-exporter, allowing to create a nice Grafana panel :

<img width="603" alt="Capture d’écran 2024-04-15 à 15 59 38" src="https://github.com/Kirael12/cardano-version/assets/113426048/72a30d27-c9a5-48ff-84e2-71f0f3bafcfd">

It can be useful to monitor cardano version on your nodes.

# Pre-requisites

Prometheus Node-Exporter must be installed.

# How to install

Note 1 : the scripts exports 2 metric files to the directory : /var/lib/prometheus/node-exporter/. Make sure your prometheus node-exporter is installed with this path. If not, modify the script accordingly to your setup

Note 2 : the script must be used with root privilege in order to write into the prometheus node-exporter protected directory.

1. Copy cardano-version.sh to the folder of your choice (ex: /root/scripts/cardano-version.sh)

2. Make the script executable

```shell
sudo chmod +x /root/scripts/cardano-version.sh
```

3. Create a root cronjob

```shell
sudo crontab -e
```

This line will run the script once a day at 00:00 :
```shell
0 0 * * * /root/scripts/cardano-version.sh
```

# How to create the Grafana Panel

Now the tricky part : setting up a Grafana Panel to monitor cardano-version.

## Step 1 : create a new panel and the 7 following queries inside

Query A Metric : cardano_current_maj

Query B Metric : cardano_current_mid

Query C Metric : cardano_current_low

Query D Metric : latest

Query E Metric : cardano_latest_maj

Query F Metric : cardano_latest_mid

Query G Metric : cardano_latest_low

## Step 2 : change the panel type to "stat"

<img width="409" alt="Capture d’écran 2024-04-15 à 15 27 32" src="https://github.com/Kirael12/cardano-version/assets/113426048/c9b562d7-824c-4dd9-9e06-3f10910f6f9a">


## Step 3 : transform the output

You need to apply 5 transformations to the queries output. To do that, go to the tab "Transform". Here are the 5 transformation types you need to apply **in that specific order** :

<img width="790" alt="Capture d’écran 2024-04-15 à 14 06 00" src="https://github.com/Kirael12/cardano-version/assets/113426048/a0d233d5-87b2-4e02-9787-8202578961f9">

---

* **First Transformation : make the metric "latest" a boolean :**

<img width="1057" alt="Capture d’écran 2024-04-15 à 13 56 06" src="https://github.com/Kirael12/cardano-version/assets/113426048/f1b712fc-1a5b-41ce-bac0-2944f3465a75">

---

* **Second Transformation : merge the 3 metrics "cardano_current_X" into 1 row :**

<img width="1053" alt="Capture d’écran 2024-04-15 à 13 57 55" src="https://github.com/Kirael12/cardano-version/assets/113426048/df6e1b32-d397-445b-96a5-a981a83d9ac1">

---

* **Third Transformation : merge the 3 metrics "cardano_latest_X" into 1 row :**

<img width="864" alt="Capture d’écran 2024-04-15 à 14 10 35" src="https://github.com/Kirael12/cardano-version/assets/113426048/68ac6465-3b4d-4280-8bfa-ee6da0f51cb0">

---

* **Fourth Transformation : make the 2 new merged row, text format:**

<img width="870" alt="Capture d’écran 2024-04-15 à 15 07 17" src="https://github.com/Kirael12/cardano-version/assets/113426048/ee311846-b49f-4709-a89b-7a73d677760d">

---

* **Fifth Transformation : organize new rows, hide date and old rows, rename:**

<img width="868" alt="Capture d’écran 2024-04-15 à 15 08 41" src="https://github.com/Kirael12/cardano-version/assets/113426048/ded774ed-b7a4-4e1a-9197-06495330194d">

---

## Step 4 : adjust panel settings

* **Display Last Calculation and All Fields**

<img width="391" alt="Capture d’écran 2024-04-15 à 15 33 54" src="https://github.com/Kirael12/cardano-version/assets/113426048/f33d9bb9-814e-4e54-a125-9ddbd5c7e53a">

---

* **Display Value and Name, disable Graph Mode**

<img width="396" alt="Capture d’écran 2024-04-15 à 15 34 52" src="https://github.com/Kirael12/cardano-version/assets/113426048/8e261a88-16f0-4e55-9b4a-7908dfd56b72">

---

* **Value mapping : make a regx to transform coma into dots**

<img width="310" alt="Capture d’écran 2024-04-15 à 15 39 30" src="https://github.com/Kirael12/cardano-version/assets/113426048/3b13d9c0-b88c-49d3-b98d-a3c056c5ea54">
<img width="972" alt="Capture d’écran 2024-04-15 à 15 36 35" src="https://github.com/Kirael12/cardano-version/assets/113426048/164c1532-fb43-4d59-bbd0-6680c6ac5326">

---

That's it. You can adjust color scheme, text size, etc
You can aslo setup an Alerting rule, when the boolean metric "Latest version installed" goes below 1

# Changelog

v1.0.0 (april 2024)

- Initial release


