package main

import (
	"context"

	"go.uber.org/atomic"
	"go.uber.org/zap"
	health "google.golang.org/grpc/health/grpc_health_v1"
)

type gRPCHealthServer struct {
	logger            *zap.SugaredLogger
	requestedShutdown *atomic.Bool
	health.UnimplementedHealthServer
}

// newGRPCHealthServer creates a new HealthServer.  The address of a boolean to act as a "please
// shutdown now" can be given to cause the service to return that it is not serving and shutting
// down
//
// This can be used with
//  health.RegisterHealthcheckServer(
//      gRPCServer,  // grpc.NewServer(...)
//	newGRPCHealthServer(aLogger, requestedShutdown),
//  )
func newGRPCHealthServer(l *zap.SugaredLogger, requestedShutdown *atomic.Bool) health.HealthServer {
	return &gRPCHealthServer{
		logger:            l,
		requestedShutdown: requestedShutdown,
	}
}

// Check polls the status, one-shot.
func (s *gRPCHealthServer) Check(
	ctx context.Context,
	req *health.HealthCheckRequest,
) (*health.HealthCheckResponse, error) {
	resp := s.getServerHealthStatus()
	return resp, nil
}

// Watch actively sends the response to an existing server.
func (s *gRPCHealthServer) Watch(
	req *health.HealthCheckRequest,
	watchServer health.Health_WatchServer,
) error {
	if err := watchServer.Send(s.getServerHealthStatus()); err != nil {
		return err
	}
	return nil
}

func (s *gRPCHealthServer) getServerHealthStatus() *health.HealthCheckResponse {
	if s.requestedShutdown.Load() {
		s.logger.Info("gRPCHealthServer received shutting signal")
		return &health.HealthCheckResponse{Status: health.HealthCheckResponse_NOT_SERVING}
	}

	return &health.HealthCheckResponse{Status: health.HealthCheckResponse_SERVING}
}
