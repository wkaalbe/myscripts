#!/usr/bin/python
''' This script takes 2 arguments. 1st is a file containing the hosts list.
    2nd is command(s) within double quotes that needs to be executed on the remote host.
    At the prompts please enter the user's password.
'''
import pexpect
import getpass
import sys

PASSWORD=".ssword.*"

def ssh_command (user, host, password, command):
    """This runs a command on the remote host. This returns a
    pexpect.spawn object. This handles the case when you try
    to connect to a new host and ssh asks you if you want to
    accept the public key fingerprint and continue connecting.
    """
    ssh_newkey = 'Are you sure you want to continue connecting (yes/no)?'
    child = pexpect.spawn('ssh -tql %s %s %s'%(user, host, command))
    i = child.expect([ssh_newkey, PASSWORD, pexpect.TIMEOUT])
    if i == 0: # First Time access - send yes to connect.
       child.sendline ('yes')
       child.sendline("\r")
       child.expect (PASSWORD)
       i = child.expect([PASSWORD,pexpect.TIMEOUT])
       if i == 0: # prompted for password
          child.sendline(password)
       elif i == 1: # Got Timeout
          print 'ERROR!'
          print 'SSH could not login. Here is what SSH said:'
          print child.before, child.after
          print str(child)
          return None
    if i == 1: # Asked for Password - provide it.
       child.sendline(password)
    elif i == 2:
         print 'ERROR!'
         print 'SSH could not login. Here is what SSH said:'
         print child.before, child.after
         print str(child)
         return None
    return child


#host = raw_input('Hostname: ')
#user = raw_input('User: ')
user = sys.argv[3]
password = getpass.getpass('Password: ')
hostsFile = sys.argv[1]
execRemoteCommand = sys.argv[2]

for host in open(hostsFile):         # Use file iterators
    print(host)
    if host.startswith('#'):
       print "Ignoring " + host
    else:
       child = ssh_command (user, host, password, execRemoteCommand)
       child.expect(pexpect.EOF)
       print child.before
    print "##############################################################################################"
