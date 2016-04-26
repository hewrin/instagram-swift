//
//  AWSConfig.swift
//  InstagramClone
//
//  Created by Faris Roslan on 25/04/2016.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import Foundation
import AWSS3


// configure S3
   let S3BucketName = "next-instagram"

// configure authentication with Cognito

   let CognitoIdentityPoolId = "us-east-1:ac7becf0-bd06-4082-99e8-6320825e0edd"
   let CognitoRegionType = AWSRegionType.USEast1
   let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.USEast1, identityPoolId: CognitoIdentityPoolId)
   let DefaultServiceRegionType = AWSRegionType.USEast1


