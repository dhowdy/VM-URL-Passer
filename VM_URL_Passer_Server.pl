#!/usr/bin/perl
use IO::Socket::INET;

# auto-flush on socket
$| = 1;

# creating a listening socket
my $socket = new IO::Socket::INET (
    LocalHost => '0.0.0.0',
    LocalPort => '7777',
    Proto => 'tcp',
    Listen => 5,
    Reuse => 1
);
die "cannot create socket $!\n" unless $socket;
print "Running on port 7777\n";

while(1)
{
    # waiting for a new client connection
    my $client_socket = $socket->accept();

    # get information about a newly connected client
    my $client_address = $client_socket->peerhost();
    my $client_port = $client_socket->peerport();
    #print "connection from $client_address:$client_port\n";

    # read up to 1024 characters from the connected client
    my $data = ""; 
    $client_socket->recv($data, 4096);
    my @datastring = split('~~',$data);
    if ($datastring[0] eq "myweakasspassword"){
         print "received data: $datastring[1]\n";
         system("'/usr/bin/google-chrome' \"$datastring[1]\"");
    }else{
         print "Wrong password.";
    }   

    # write response data to the connected client
    $data = "ok";
    $client_socket->send($data);

    # notify client that response has been sent
    shutdown($client_socket, 1); 
}

