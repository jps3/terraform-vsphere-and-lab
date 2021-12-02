# terraform-vsphere-and-lab

Using terraform and packer to build a virtual information security lab on vSphere, based on the lab architecture featured in Applied Network Defense’s (AND’s) “[Building Virtual Labs](https://www.networkdefense.io/library/building-virtual-security-labs/about/)” online course.

While that course utilizes Splunk, most likely I will substitute here with HELK or Security Onion since I am more familiar and comfortable with Elastic-based approaches.

Work in progress.

# Infrastructure

- vSphere
	- esx1.lab.local 2017-ish ThinkServer TS140 running ESXi 6.7 (last compatible with ATTO ExpressSAS H680 to use with 4-bay 1U JBOD hand-me-downs)
	- esx2.lab.local 2018-ish Intel NUC running ESXi 7.x running vSphere appliance
	- esx3.lab.local and esx4.lab.local 2012 Mac Minis running ESXi 7.x not currently used in this repo

# VM Templates

- [x] pfSense
- [ ] OpenBSD as ssh bastion host _tbd_
- [ ] Ubuntu 18.04 _tbd_
- [ ] Ubuntu 20.04 _tbd_

## pfSense 2.5.2 Gateway

```bash
cd packer/pfsense
packer validate .
packer build .
```

After terraform deploys will need to configure manually, restore a previous backup, or see about creating a XML “backup” template to use. This is a rather manual-labor intensive part.

## OpenBSD 7.0 Bastion

```bash
cd packer/openbsd
packer validate .
packer build .
```

