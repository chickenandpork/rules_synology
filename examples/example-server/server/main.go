// Forked from https://github.com/grpc/grpc-go.
/*
 *
 * Copyright 2015 gRPC authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package main

import (
	"flag"
	"log"
	"net"

	pb "github.com/chickenandpork/bazel-spk-go-grpc-simpleserver/api"
	//pb "github.com/chickenandpork/rules_synology/examples/example-server/api"

	"go.uber.org/atomic"
	"go.uber.org/zap"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"google.golang.org/grpc/health/grpc_health_v1"
	"google.golang.org/grpc/reflection"
)

var (
	port        = ":50051"
	reqShutdown atomic.Bool
)

func init() {
	flag.StringVar(
		&port,
		"listen",
		":50051",
		"host/port to listen on for connections (localhost:12345, :50055, etc)",
	)
}

// server is used to implement helloworld.GreeterServer.
type server struct{}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	return &pb.HelloReply{Message: "Hello " + in.Name}, nil
}

// SayHelloAgain implements helloworld.GreeterServer
func (s *server) SayHelloAgain(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	return &pb.HelloReply{Message: "Hello again " + in.Name}, nil
}

func main() {
	flag.Parse()

	logger := zap.NewExample()
	defer logger.Sync()

	undo := zap.RedirectStdLog(logger)
	defer undo()

	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterGreeterServer(s, &server{})

	// layer on a healthcheck server.  cuz Health
	grpc_health_v1.RegisterHealthServer(s, newGRPCHealthServer(logger.Sugar(), &reqShutdown))

	// Register reflection service on gRPC server.
	reflection.Register(s)
	log.Printf("Services (Greeter, Reflection, health) registered; listening on \"%s\"", port)
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
