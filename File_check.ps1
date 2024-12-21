

Write-Host ""

Write-Host "Select Operation"

Write-Host "A) Collect new Baseline?"

Write-Host "B) Begin MOnitoring files with new baseline"

Write-Host ""



$response = Read-Host -Prompt "Enter 'A' or'B'"



Function CalcHash($filepath) {

    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512

    return $filehash

}



Function DelIfExist() {

    $check = Test-Path -Path .\hash.txt 



    if ($check) {

        Remove-Item -Path .\hash.txt

        }

}





if ($response -eq "A".ToUpper()) {

 #Checks if file exists and deletes it if it is

    DelIfExist

 #Create new file Hashes for target files and store them in a file



 #Collect all files in target folder

    $files = Get-ChildItem -Path .\Files



 #For each file calc hash and store in a file

     foreach ($x in $files) {

        $hash = CalcHash $x.FullName

        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\hash.txt -Append

            }





 }

elseif($response -eq "B".ToUpper()) {



    $hashdict=@{}

    #Load file|hash from hash.txt and store it in dictionary

    $filePathandHash = Get-Content -Path .\hash.txt

    

    foreach ($f in $filePathandHash) {

        $hashdict.add($f.Split("|")[0],$f.Split("|")[1])

       

    }

    while($true) {

        Start-Sleep -Seconds 3

        $files = Get-ChildItem -Path .\Files



         #For each file calc hash and store in a file

             foreach ($x in $files) {

                $hash = CalcHash $x.FullName

                #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\hash.txt -Append



                if ($hashdict[$hash.Path] -eq $null) {

                    #new file created notify user

                    Write-Host "$($hash.Path) hass been created!" -ForegroundColor Yellow

                    }

                else {

                    if($hashdict[$hash.Path] -eq $hash.Hash) {

                        #The file has not been changed

                    }

                    else {

                        #File has been compromised, Notify the user!

                        Write-Host "$($hash.Path) has changed!" -ForegroundColor Yellow

                    }

                }

    }           

    }

    

}
