#!/bin/bash
just_nslookup() {
	until nslookup $1; do echo waiting for $1; sleep 2; done;
}

just_nslookup $1
