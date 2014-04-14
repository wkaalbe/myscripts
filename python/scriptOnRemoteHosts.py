#!/usr/bin/python
# AUTHOR: csmunuku@gmail.com
####################################################################################################
import pexpect
import getpass
import sys

# sys.argv[1] will be the file containing the list of Hosts
print sys.argv[1]
# sys.argv[2] will be the script filename which you want to copy to remote hosts and then execute it.
print sys.argv[2]

localfile = sys.argv[2]
# name you want to give to the remote file.  can be made as an argument as well..
remotefile = "/tmp/test.sh"
execRemoteCommand = "sh test.sh"
PASSWORD=".ssword.*"

#host = raw_input('Hostname: ')
#user = raw_input('User: ')
user = 'inquira'
password = getpass.getpass('Password: ')

def scp_command (user, host, password, fileToCopy):
    ssh_newkey = 'Are you sure you want to continue connecting (yes/no)?'
    child = pexpect.spawn('scp "%s" "%s@%s:%s"' % (localfile, user, host, remotefile))
    i = child.expect([ssh_newkey, PASSWORD, pexpect.TIMEOUT])
    if i == 0: # First Time access - send yes to connect.
       print "First Time access"
       child.sendline ('yes')
       print "sent yes"
       child.sendline("\r")
       print "sent \\r"
       child.expect (PASSWORD)
       print "expect password done"
       i = child.expect([PASSWORD,pexpect.TIMEOUT])
       if i == 0: # prompted for password
          print "I am being prompted for Password here:"
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

def ssh_command (user, host, password, command):
    """This runs a command on the remote host. This returns a
    pexpect.spawn object. This handles the case when you try
    to connect to a new host and ssh asks you if you want to
    accept the public key fingerprint and continue connecting.
    """
    ssh_newkey = 'Are you sure you want to continue connecting (yes/no)?'
    child = pexpect.spawn('ssh -l %s %s %s'%(user, host, command))
    i = child.expect([ssh_newkey, PASSWORD, pexpect.TIMEOUT])
    if i == 0: # First Time access - send yes to connect.
       child.sendline ('yes')
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


# Copy the file in first iteration
for host in open(sys.argv[1]):         # Use file iterators
    print(host)
#    os.system('scp "%s" "%s:%s"' % (localfile, line, remotefile) )
    child = scp_command (user, host.rstrip(), password, localfile)
    child.expect(pexpect.EOF)
    print child.before

# Execute the command in the second iteration
for host in open(sys.argv[1]):         # Use file iterators
    print(host)
    child = ssh_command (user, host, password, execRemoteCommand)
    child.expect(pexpect.EOF)
    print child.before
