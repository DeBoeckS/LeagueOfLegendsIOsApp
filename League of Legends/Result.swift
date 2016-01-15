//
//  Result.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//

enum Result<T>
{
    case Success(T)
    case Failure(Service.Error)
}

